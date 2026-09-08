import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../domain/entities/product_summary.dart';

class DropCard extends StatelessWidget {
  final ProductSummary product;
  final VoidCallback onTap;

  const DropCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);
    return PressScale(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInNetworkImage(
                    url: product.imageUrl,
                    width: 150,
                    height: 190,
                    fallback: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: product.imageGradient,
                        ),
                      ),
                    ),
                  ),
                ),
                if (product.isMadeToMeasure)
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.card.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(l10n.mtmBadge,
                          style: AppTextStyles.caption.copyWith(color: AppColors.teal, fontSize: 10)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 7),
            Text(product.name.resolve(locale),
                maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.label.copyWith(fontSize: 13)),
            Text(product.seller.resolve(locale),
                maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.caption.copyWith(fontSize: 11)),
            Text(product.price.resolve(locale),
                maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.priceSmall),
          ],
        ),
      ),
    );
  }
}
