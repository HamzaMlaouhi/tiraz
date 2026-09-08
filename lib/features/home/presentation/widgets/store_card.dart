import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../domain/entities/store.dart';

/// A storefront preview in the home feed's horizontal "Stores across the
/// UAE" rail — banner photo, an overlapping logo avatar, and the store's
/// name/emirate/rating. Tapping opens the full store sheet.
class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback onTap;

  const StoreCard({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return PressScale(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
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
                    height: 88,
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
                if (store.offer != null)
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    end: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9A441),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        store.offer!.resolve(locale),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                PositionedDirectional(
                  start: 12,
                  bottom: -18,
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                    child: ClipOval(
                      child: Hero(
                        tag: 'store-logo-${store.id}',
                        child: FadeInNetworkImage(
                          url: store.logoImageUrl,
                          width: 36,
                          height: 36,
                          fallback: Container(
                            color: AppColors.tealBg,
                            alignment: Alignment.center,
                            child: Text(
                              store.name.resolve(locale).characters.first,
                              style: AppTextStyles.label.copyWith(color: AppColors.teal),
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
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name.resolve(locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(store.emirate.resolve(locale),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(fontSize: 11)),
                      ),
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFFD9A441)),
                      const SizedBox(width: 2),
                      Text(store.rating.toStringAsFixed(1), style: AppTextStyles.caption.copyWith(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(store.productCount.resolve(locale),
                      style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.teal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
