import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../domain/entities/seller_product.dart';
import 'seller_product_image.dart';

/// A listing in the seller's own product grid — like [DropCard], but with
/// a remove affordance alongside the tap-through to [SellerProductDetailPage].
class SellerProductTile extends StatelessWidget {
  final SellerProduct product;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const SellerProductTile({super.key, required this.product, required this.onTap, required this.onRemove});

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
                  child: SellerProductImage(
                    imageUrl: product.imageUrl,
                    imageBytes: product.imageBytes,
                    width: 150,
                    height: 190,
                    fallback: const DecoratedBox(decoration: BoxDecoration(color: AppColors.tealBg)),
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
                if (product.isHandmade)
                  PositionedDirectional(
                    bottom: 8,
                    start: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(999)),
                      child: Text(
                        l10n.sellerHandmadeBadge,
                        style: AppTextStyles.caption.copyWith(color: AppColors.card, fontSize: 10),
                      ),
                    ),
                  ),
                PositionedDirectional(
                  top: 6,
                  end: 6,
                  child: Material(
                    color: AppColors.card.withOpacity(0.92),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onRemove,
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.close_rounded, size: 15, color: AppColors.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(product.name,
                maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.label.copyWith(fontSize: 13)),
            Text(formatAed(product.totalPriceAed.round(), locale), style: AppTextStyles.priceSmall),
          ],
        ),
      ),
    );
  }
}
