import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/image_slot.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/selectable_chip.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/product_cubit.dart';
import '../widgets/fit_zone_bar.dart';
import '../widgets/mode_tabs.dart';

class ProductPage extends StatelessWidget {
  final String productId;
  final VoidCallback onBack;
  final VoidCallback onOpenCart;

  const ProductPage({super.key, required this.productId, required this.onBack, required this.onOpenCart});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCubit>(
      create: (_) => sl<ProductCubit>()..load(productId),
      child: _ProductView(onBack: onBack, onOpenCart: onOpenCart),
    );
  }
}

class _ProductView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onOpenCart;

  const _ProductView({required this.onBack, required this.onOpenCart});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state.status == ProductStatus.loading || state.detail == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.teal));
            }
            if (state.status == ProductStatus.error) {
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

            final d = state.detail!;
            final isMtm = state.mode == ProductMode.madeToMeasure;
            final price = isMtm ? d.priceMtm : d.priceRtw;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                    child: Row(
                      children: [
                        RoundIconButton.back(onPressed: onBack),
                        const SizedBox(width: 10),
                        Text(d.seller.resolve(locale), style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: ImageSlot(
                            placeholder: l10n.appName,
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: d.imageGradient,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(3, (i) {
                            const colors = [Color(0xFFE9DFCD), Color(0xFFDED4C0), Color(0xFFDFE9E7)];
                            return Padding(
                              padding: EdgeInsetsDirectional.only(end: i == 2 ? 0 : 8),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Text(d.name.resolve(locale), style: AppTextStyles.h1)),
                            const SizedBox(width: 10),
                            Text(price.resolve(locale), style: AppTextStyles.price),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text('★ ${d.ratingValue}', style: AppTextStyles.bodyMuted.copyWith(height: 1)),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(999)),
                              child: Text(
                                d.fitAccuracyLabel.resolve(locale),
                                style: AppTextStyles.caption.copyWith(color: AppColors.tealDark, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ModeTabs(
                          mode: state.mode,
                          onChanged: (m) => context.read<ProductCubit>().setMode(m),
                        ),
                        const SizedBox(height: 12),
                        if (!isMtm) ...[
                          Row(
                            children: List.generate(d.sizes.length, (i) {
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(end: 8),
                                child: SelectableChip(
                                  label: d.sizes[i],
                                  selected: state.selectedSizeIndex == i,
                                  pill: false,
                                  onTap: () => context.read<ProductCubit>().selectSize(i),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.deliveredTomorrow,
                            style: AppTextStyles.label.copyWith(color: AppColors.teal, fontSize: 12.5),
                          ),
                        ] else ...[
                          Text(l10n.whoIsThisFor, style: AppTextStyles.label),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              SelectableChip(
                                label: l10n.profileMe,
                                selected: state.selectedProfileIndex == 0,
                                onTap: () => context.read<ProductCubit>().selectProfile(0),
                              ),
                              SelectableChip(
                                label: l10n.addNewProfile,
                                selected: state.selectedProfileIndex == 1,
                                onTap: () => context.read<ProductCubit>().selectProfile(1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                            decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.mtmGuarantee,
                                  style: AppTextStyles.label.copyWith(color: AppColors.tealDark, fontSize: 12.5),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.mtmAlteration,
                                  style: AppTextStyles.bodyMuted.copyWith(color: AppColors.tealMuted, fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.mtmLeadTime(d.seller.resolve(locale)),
                            style: AppTextStyles.bodyMuted.copyWith(fontSize: 12),
                          ),
                        ],
                        const Divider(height: 30),
                        Text(l10n.fabricCareTitle, style: AppTextStyles.label),
                        const SizedBox(height: 6),
                        Text(d.fabricBody.resolve(locale), style: AppTextStyles.bodyMuted.copyWith(fontSize: 12.5)),
                        const Divider(height: 30),
                        Text(l10n.howDidItFit, style: AppTextStyles.label),
                        const SizedBox(height: 10),
                        ...d.fitZones.map((z) => FitZoneBar(zone: z)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.reviewQuote.resolve(locale),
                                style: AppTextStyles.body.copyWith(fontSize: 12.5, color: const Color(0xFF3D3527)),
                              ),
                              const SizedBox(height: 5),
                              Text(d.reviewBy.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          label: isMtm ? l10n.orderMtmCta(price.resolve(locale)) : l10n.addToCartCta(price.resolve(locale)),
                          onPressed: () {
                            final priceAed = isMtm ? d.priceMtmAed : d.priceRtwAed;
                            final variant = isMtm
                                ? LocalizedText(
                                    ar: 'تفصيل حسب ملف "${state.selectedProfileIndex == 0 ? l10n.profileMe : l10n.addNewProfile}" — ${d.fabricShort.ar}',
                                    en: 'Made-to-measure, profile "${state.selectedProfileIndex == 0 ? l10n.profileMe : l10n.addNewProfile}" — ${d.fabricShort.en}',
                                  )
                                : LocalizedText(
                                    ar: 'مقاس ${d.sizes[state.selectedSizeIndex]} — ${d.fabricShort.ar}',
                                    en: 'Size ${d.sizes[state.selectedSizeIndex]} — ${d.fabricShort.en}',
                                  );
                            const leadMtm = LocalizedText(ar: 'تفصيل — قبل 8 فبراير', en: 'MTM — before Feb 8');
                            const leadRtw = LocalizedText(ar: 'جاهز — التوصيل غداً', en: 'RTW — tomorrow');
                            sl<CartCubit>().addItem(CartItem(
                              id: '${d.id}-${state.mode.name}-${DateTime.now().millisecondsSinceEpoch}',
                              seller: d.seller,
                              leadLabel: isMtm ? leadMtm : leadRtw,
                              itemName: d.name,
                              variant: variant,
                              priceAed: priceAed,
                              imageGradient: d.imageGradient,
                            ));
                            context.read<ProductCubit>().addToCart();
                            onOpenCart();
                          },
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
