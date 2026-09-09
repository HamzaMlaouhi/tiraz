import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../domain/entities/jalabiya_quality.dart';
import '../../domain/entities/seller_product.dart';
import '../cubit/seller_cubit.dart';
import '../widgets/seller_product_image.dart';

/// The full profile of one of the seller's own listings — a bigger photo,
/// the description, the garment's dimensions, its quality tier, and the
/// base/handmade/total price breakdown.
class SellerProductDetailPage extends StatelessWidget {
  final String productId;
  final VoidCallback onBack;

  const SellerProductDetailPage({super.key, required this.productId, required this.onBack});

  String _qualityLabel(AppLocalizations l10n, JalabiyaQuality quality) {
    switch (quality) {
      case JalabiyaQuality.standard:
        return l10n.sellerQualityStandard;
      case JalabiyaQuality.premium:
        return l10n.sellerQualityPremium;
      case JalabiyaQuality.luxury:
        return l10n.sellerQualityLuxury;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          bloc: sl<SellerCubit>(),
          builder: (context, state) {
            SellerProduct? product;
            for (final p in state.products) {
              if (p.id == productId) {
                product = p;
                break;
              }
            }

            if (product == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: onBack, child: Text(l10n.retry)),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                    child: RoundIconButton.back(onPressed: onBack),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SellerProductImage(
                        imageUrl: product.imageUrl,
                        imageBytes: product.imageBytes,
                        width: double.infinity,
                        height: 260,
                        fallback: const DecoratedBox(decoration: BoxDecoration(color: AppColors.tealBg)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _Badge(label: product.isMadeToMeasure ? l10n.madeToMeasure : l10n.readyToWear),
                            _Badge(label: _qualityLabel(l10n, product.quality)),
                            if (product.isHandmade) _Badge(label: l10n.sellerHandmadeBadge, filled: true),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(product.name, style: AppTextStyles.h1),
                        if (product.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(product.description, style: AppTextStyles.body.copyWith(fontSize: 13, height: 1.6)),
                        ],
                        const SizedBox(height: 18),
                        Text(l10n.sellerDimensionsLabel, style: AppTextStyles.sectionTitle),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _DimensionStat(label: l10n.sellerLengthLabel, cm: product.lengthCm)),
                            const SizedBox(width: 10),
                            Expanded(child: _DimensionStat(label: l10n.sellerChestLabel, cm: product.chestCm)),
                            const SizedBox(width: 10),
                            Expanded(child: _DimensionStat(label: l10n.sellerSleeveLabel, cm: product.sleeveCm)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              _PriceRow(
                                  label: l10n.sellerBasePriceLabel, value: formatAed(product.priceAed.round(), locale)),
                              if (product.isHandmade) ...[
                                const SizedBox(height: 8),
                                _PriceRow(
                                  label: l10n.sellerHandmadeExtraLabel,
                                  value: '+ ${formatAed(product.handmadeExtraCostAed.round(), locale)}',
                                  valueColor: AppColors.teal,
                                ),
                                const Divider(height: 20),
                                _PriceRow(
                                  label: l10n.sellerTotalPriceLabel,
                                  value: formatAed(product.totalPriceAed.round(), locale),
                                  bold: true,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool filled;

  const _Badge({required this.label, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? AppColors.teal : AppColors.tealBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: filled ? AppColors.card : AppColors.tealDark, fontSize: 11),
      ),
    );
  }
}

class _DimensionStat extends StatelessWidget {
  final String label;
  final double cm;

  const _DimensionStat({required this.label, required this.cm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text('${cm.toStringAsFixed(0)} cm', style: AppTextStyles.label.copyWith(fontSize: 14)),
          const SizedBox(height: 3),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _PriceRow({required this.label, required this.value, this.valueColor, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMuted.copyWith(fontSize: 12.5, height: 1)),
        Text(
          value,
          style: (bold ? AppTextStyles.h3 : AppTextStyles.label).copyWith(fontSize: bold ? 16 : 13, color: valueColor),
        ),
      ],
    );
  }
}
