import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/cart_cubit.dart';

class CartPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onBrowse;
  final VoidCallback onCheckout;

  const CartPage({super.key, required this.onBack, required this.onBrowse, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          bloc: sl<CartCubit>(),
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Row(
                  children: [
                    RoundIconButton.back(onPressed: onBack),
                    const SizedBox(width: 10),
                    Text(l10n.cartTitle, style: AppTextStyles.h2),
                  ],
                ),
                if (state.items.isEmpty) ...[
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Text(l10n.cartEmptyMessage, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted.copyWith(height: 1.6)),
                      const SizedBox(height: 14),
                      ElevatedButton(onPressed: onBrowse, child: Text(l10n.browseDesigns, style: AppTextStyles.buttonPrimary)),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  ...state.items.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.seller.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 13)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(999)),
                                child: Text(
                                  item.leadLabel.resolve(locale),
                                  style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.tealDark),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 64,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: item.imageGradient),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.itemName.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                                    const SizedBox(height: 3),
                                    Text(item.variant.resolve(locale), style: AppTextStyles.bodyMuted.copyWith(fontSize: 11.5, height: 1.6)),
                                    const SizedBox(height: 6),
                                    Text(formatAed(item.priceAed, locale), style: AppTextStyles.priceSmall),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  Material(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => sl<CartCubit>().toggleGift(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.cartGiftTitle, style: AppTextStyles.label.copyWith(fontSize: 13)),
                                  Text(l10n.cartGiftSubtitle, style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
                                ],
                              ),
                            ),
                            Switch(
                              value: state.giftWrap,
                              activeColor: AppColors.card,
                              activeTrackColor: AppColors.teal,
                              onChanged: (_) => sl<CartCubit>().toggleGift(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _summaryRow(l10n.cartSubtotal, formatAed(state.subtotalAed, locale)),
                      const SizedBox(height: 7),
                      _summaryRow(l10n.cartShipping, formatAed(CartState.shippingAed, locale)),
                      const Divider(height: 24),
                      _summaryRow(l10n.cartTotal, formatAed(state.totalAed, locale), emphasized: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(label: l10n.cartCheckoutCta, onPressed: onCheckout),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool emphasized = false}) {
    final style = emphasized
        ? AppTextStyles.label.copyWith(fontSize: 15, fontWeight: FontWeight.w700)
        : AppTextStyles.bodyMuted.copyWith(fontSize: 12.5, height: 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: style), Text(value, style: style)],
    );
  }
}
