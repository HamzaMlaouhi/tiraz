import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../domain/entities/store.dart';
import 'drop_card.dart';

/// The store's full profile, opened as a modal sheet from its [StoreCard]
/// on the home feed — banner, logo, rating, and its preview products
/// (tapping one hands off to the existing product detail route).
class StoreSheet extends StatelessWidget {
  final Store store;
  final void Function(String productId) onOpenProduct;

  const StoreSheet({super.key, required this.store, required this.onOpenProduct});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ColoredBox(
          color: AppColors.surface,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Hero(
                            tag: 'store-banner-${store.id}',
                            child: FadeInNetworkImage(
                              url: store.bannerImageUrl,
                              width: double.infinity,
                              height: 150,
                              fallback: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: store.fallbackGradient,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            top: 10,
                            end: 10,
                            child: Material(
                              color: AppColors.card.withOpacity(0.92),
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => Navigator.of(context).pop(),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.close_rounded, size: 18, color: AppColors.textPrimary),
                                ),
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            start: 18,
                            bottom: -26,
                            child: Container(
                              width: 56,
                              height: 56,
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                              child: ClipOval(
                                child: Hero(
                                  tag: 'store-logo-${store.id}',
                                  child: FadeInNetworkImage(
                                    url: store.logoImageUrl,
                                    width: 50,
                                    height: 50,
                                    fallback: Container(
                                      color: AppColors.tealBg,
                                      alignment: Alignment.center,
                                      child: Text(
                                        store.name.resolve(locale).characters.first,
                                        style: AppTextStyles.h3.copyWith(color: AppColors.teal),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 34, 18, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.name.resolve(locale), style: AppTextStyles.h2),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 3),
                                Text(store.emirate.resolve(locale), style: AppTextStyles.bodyMuted),
                                const SizedBox(width: 12),
                                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFD9A441)),
                                const SizedBox(width: 3),
                                Text(l10n.ratingLabel(store.rating.toStringAsFixed(1), '${store.reviewCount}'),
                                    style: AppTextStyles.bodyMuted),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(store.productCount.resolve(locale),
                                style: AppTextStyles.caption.copyWith(color: AppColors.teal)),
                            if (store.offer != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBF1DD),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_offer_rounded, size: 15, color: Color(0xFFB07E1F)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        store.offer!.resolve(locale),
                                        style: AppTextStyles.label
                                            .copyWith(color: const Color(0xFF8A5F14), fontSize: 12.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 22),
                            Text(l10n.storeSheetProductsTitle, style: AppTextStyles.sectionTitle),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 16,
                          children: store.products
                              .map((product) => DropCard(
                                    product: product,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      onOpenProduct(product.id);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
