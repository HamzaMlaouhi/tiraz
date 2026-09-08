import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/wallet_cubit.dart';

class WalletPage extends StatelessWidget {
  final VoidCallback onBack;

  const WalletPage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WalletCubit, WalletState>(
          bloc: sl<WalletCubit>(),
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Row(
                  children: [
                    RoundIconButton.back(onPressed: onBack),
                    const SizedBox(width: 10),
                    Text(l10n.walletTitle, style: AppTextStyles.h2),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Text(formatAed(state.balanceAed, locale), style: AppTextStyles.h1.copyWith(fontSize: 30, color: AppColors.tealDark)),
                      const SizedBox(height: 4),
                      Text(l10n.walletBalanceLabel, style: AppTextStyles.caption.copyWith(color: AppColors.tealMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  decoration: BoxDecoration(color: AppColors.sandBg, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.walletTip, style: AppTextStyles.bodyMuted.copyWith(color: AppColors.sandText, fontSize: 12)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => sl<WalletCubit>().copyInviteLink(),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10)),
                        child: Text(l10n.walletInviteCta, style: AppTextStyles.buttonPrimary.copyWith(fontSize: 12.5)),
                      ),
                      if (state.copied) ...[
                        const SizedBox(height: 8),
                        Text(l10n.walletCopiedMessage, style: AppTextStyles.label.copyWith(color: AppColors.teal, fontSize: 11.5)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.walletHistoryTitle, style: AppTextStyles.label),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: List.generate(state.history.length, (i) {
                      final t = state.history[i];
                      final positive = t.amountAed > 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          border: i == state.history.length - 1
                              ? null
                              : const Border(bottom: BorderSide(color: Color(0xFFF2EDE3))),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.name.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 12.5)),
                                  Text(t.date.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11)),
                                ],
                              ),
                            ),
                            Text(
                              '${positive ? '+' : '−'}${formatAed(t.amountAed.abs(), locale)}',
                              style: AppTextStyles.label.copyWith(fontSize: 12.5, color: positive ? AppColors.teal : AppColors.error),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
