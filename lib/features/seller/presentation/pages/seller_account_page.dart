import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/seller_cubit.dart';

class SellerAccountPage extends StatelessWidget {
  final VoidCallback onSwitchToBuying;

  const SellerAccountPage({super.key, required this.onSwitchToBuying});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          bloc: sl<SellerCubit>(),
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Text(l10n.sellerAccountTitle, style: AppTextStyles.h2),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(color: AppColors.tealBg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.accountUserName.substring(0, 1),
                        style: AppTextStyles.h1.copyWith(fontSize: 20, color: AppColors.teal),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.accountUserName, style: AppTextStyles.h3),
                        Text(state.store.name.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _Row(name: l10n.sellerYourStoreLabel, value: state.store.emirate.resolve(locale)),
                      BlocBuilder<LocaleCubit, Locale>(
                        builder: (context, currentLocale) => _Row(
                          name: l10n.accountLanguageRow,
                          value: l10n.currentLanguageName,
                          onTap: () => context.read<LocaleCubit>().toggle(),
                        ),
                      ),
                      _Row(
                        name: l10n.accountNotificationsRow,
                        sub: l10n.accountNotificationsSubtitle,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  color: AppColors.tealBg,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onSwitchToBuying,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.storefront_outlined, size: 18, color: AppColors.teal),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.sellerSwitchToBuyingCta,
                                    style: AppTextStyles.label.copyWith(color: AppColors.tealDark, fontSize: 13.5)),
                                Text(l10n.sellerSwitchToBuyingSubtitle,
                                    style: AppTextStyles.caption.copyWith(color: AppColors.tealMuted, fontSize: 11)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.teal, size: 20),
                        ],
                      ),
                    ),
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

class _Row extends StatelessWidget {
  final String name;
  final String? sub;
  final String? value;
  final VoidCallback? onTap;
  final bool isLast;

  const _Row({required this.name, this.sub, this.value, this.onTap, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF2EDE3))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                  if (sub != null) Text(sub!, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                ],
              ),
            ),
            if (value != null) Text(value!, style: AppTextStyles.label.copyWith(color: AppColors.teal, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
