import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../addresses/presentation/cubit/addresses_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../cubit/checkout_cubit.dart';

class CheckoutPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onChangeAddress;
  final void Function(String orderId) onOrderPlaced;

  const CheckoutPage({super.key, required this.onBack, required this.onChangeAddress, required this.onOrderPlaced});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CheckoutCubit>(create: (_) => CheckoutCubit()),
        BlocProvider<CartCubit>.value(value: sl<CartCubit>()),
        BlocProvider<AddressesCubit>.value(value: sl<AddressesCubit>()),
        BlocProvider<OrdersCubit>.value(value: sl<OrdersCubit>()),
      ],
      child: _CheckoutView(onBack: onBack, onChangeAddress: onChangeAddress, onOrderPlaced: onOrderPlaced),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onChangeAddress;
  final void Function(String orderId) onOrderPlaced;

  const _CheckoutView({required this.onBack, required this.onChangeAddress, required this.onOrderPlaced});

  (String, String) _paymentCopy(AppLocalizations l10n, String key) {
    switch (key) {
      case 'applePay':
        return (l10n.paymentApplePay, '');
      case 'bankCard':
        return (l10n.paymentBankCard, l10n.paymentBankCardNote);
      case 'tabby':
        return (l10n.paymentTabby, l10n.paymentTabbyNote);
      default:
        return (l10n.paymentCod, l10n.paymentCodNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final cart = context.watch<CartCubit>().state;
    final addresses = context.watch<AddressesCubit>().state;
    final selectedPayment = context.watch<CheckoutCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            Row(
              children: [
                RoundIconButton.back(onPressed: onBack),
                const SizedBox(width: 10),
                Text(l10n.checkoutTitle, style: AppTextStyles.h2),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(addresses.defaultAddress.label.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 13)),
                        Text(addresses.defaultAddress.line.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11.5, height: 1.6)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: onChangeAddress,
                    child: Text(l10n.changeLabel, style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.teal, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.checkoutEtaTitle, style: AppTextStyles.label.copyWith(color: AppColors.tealDark, fontSize: 12.5)),
                  const SizedBox(height: 4),
                  Text(l10n.checkoutEtaSubtitle, style: AppTextStyles.bodyMuted.copyWith(color: AppColors.tealMuted, fontSize: 11.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.checkoutPaymentTitle, style: AppTextStyles.label),
            const SizedBox(height: 10),
            ...List.generate(CheckoutCubit.paymentKeys.length, (i) {
              final key = CheckoutCubit.paymentKeys[i];
              final (name, note) = _paymentCopy(l10n, key);
              final selected = selectedPayment == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Material(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(13),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(13),
                    onTap: () => context.read<CheckoutCubit>().selectPayment(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: selected ? AppColors.teal : const Color(0xFFC9C0B0), width: 1.5),
                            ),
                            alignment: Alignment.center,
                            child: selected
                                ? Container(width: 9, height: 9, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.teal))
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: AppTextStyles.label.copyWith(fontSize: 13)),
                                if (note.isNotEmpty) Text(note, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            PrimaryButton(
              label: l10n.checkoutPlaceOrderCta(formatAed(cart.totalAed, locale)),
              onPressed: cart.items.isEmpty
                  ? null
                  : () {
                      final first = cart.items.first;
                      final orderId = context.read<OrdersCubit>().placeOrder(
                            itemName: first.itemName,
                            sellerMeta: first.seller,
                            imageGradient: first.imageGradient,
                          );
                      context.read<CartCubit>().clear();
                      onOrderPlaced(orderId);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
