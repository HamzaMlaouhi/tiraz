import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../fit/presentation/cubit/fit_cubit.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../../wishlist/domain/entities/wishlist_item.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onOpenOrders;
  final VoidCallback onOpenMeasurements;
  final VoidCallback onOpenWishlist;
  final VoidCallback onOpenWallet;
  final VoidCallback onOpenAddresses;
  final VoidCallback onBecomeSeller;

  const ProfilePage({
    super.key,
    required this.onOpenOrders,
    required this.onOpenMeasurements,
    required this.onOpenWishlist,
    required this.onOpenWallet,
    required this.onOpenAddresses,
    required this.onBecomeSeller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
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
                    Text(l10n.accountMemberSince, style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
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
                  BlocBuilder<OrdersCubit, OrdersState>(
                    bloc: sl<OrdersCubit>(),
                    builder: (context, state) {
                      final inProgress = state.orders.where((o) => o.status == OrderStatusKind.inProduction).length;
                      return _Row(
                        name: l10n.accountOrdersRow,
                        sub:
                            inProgress > 0 ? l10n.accountOrdersInProgress(inProgress.toString()) : l10n.accountNoOrders,
                        onTap: onOpenOrders,
                      );
                    },
                  ),
                  BlocBuilder<FitCubit, FitState>(
                    bloc: sl<FitCubit>(),
                    builder: (context, state) {
                      return _Row(
                        name: l10n.accountProfilesRow,
                        value: l10n.accountProfilesValue(state.profiles.length.toString()),
                        onTap: onOpenMeasurements,
                      );
                    },
                  ),
                  BlocBuilder<WishlistCubit, List<WishlistItem>>(
                    bloc: sl<WishlistCubit>(),
                    builder: (context, items) {
                      return _Row(
                        name: l10n.accountWishlistRow,
                        value: l10n.accountWishlistValue(items.length.toString()),
                        onTap: onOpenWishlist,
                      );
                    },
                  ),
                  BlocBuilder<WalletCubit, WalletState>(
                    bloc: sl<WalletCubit>(),
                    builder: (context, state) {
                      return _Row(
                        name: l10n.accountWalletRow,
                        sub: l10n.accountWalletSubtitle,
                        value: formatAed(state.balanceAed, locale),
                        onTap: onOpenWallet,
                      );
                    },
                  ),
                  _Row(name: l10n.addressesTitle, onTap: onOpenAddresses),
                  BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, currentLocale) {
                      return _Row(
                        name: l10n.accountLanguageRow,
                        value: l10n.currentLanguageName,
                        onTap: () => context.read<LocaleCubit>().toggle(),
                        showChevron: false,
                      );
                    },
                  ),
                  _Row(
                    name: l10n.accountNotificationsRow,
                    sub: l10n.accountNotificationsSubtitle,
                    onTap: null,
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
                onTap: onBecomeSeller,
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
                            Text(l10n.accountBecomeSellerRow,
                                style: AppTextStyles.label.copyWith(color: AppColors.tealDark, fontSize: 13.5)),
                            Text(l10n.accountBecomeSellerSubtitle,
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
  final bool showChevron;

  const _Row({
    required this.name,
    this.sub,
    this.value,
    required this.onTap,
    this.isLast = false,
    this.showChevron = true,
  });

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
            if (showChevron) const Icon(Icons.chevron_right_rounded, color: Color(0xFFC9C0B0), size: 20),
          ],
        ),
      ),
    );
  }
}
