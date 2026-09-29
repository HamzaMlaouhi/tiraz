import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../fit/presentation/cubit/fit_cubit.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../wallet/presentation/cubit/wallet_cubit.dart';
import '../../../wishlist/domain/entities/wishlist_item.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../domain/entities/user_profile.dart';
import '../cubit/account_cubit.dart';

class ProfilePage extends StatefulWidget {
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
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    sl<AccountCubit>().load();
    sl<WishlistCubit>().load();
    sl<OrdersCubit>().load();
    sl<WalletCubit>().load();
    sl<FitCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            BlocBuilder<AccountCubit, AccountState>(
              bloc: sl<AccountCubit>(),
              builder: (context, state) => _ProfileHeader(profile: state.profile),
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
                        onTap: widget.onOpenOrders,
                      );
                    },
                  ),
                  BlocBuilder<FitCubit, FitState>(
                    bloc: sl<FitCubit>(),
                    builder: (context, state) {
                      return _Row(
                        name: l10n.accountProfilesRow,
                        value: l10n.accountProfilesValue(state.profiles.length.toString()),
                        onTap: widget.onOpenMeasurements,
                      );
                    },
                  ),
                  BlocBuilder<WishlistCubit, List<WishlistItem>>(
                    bloc: sl<WishlistCubit>(),
                    builder: (context, items) {
                      return _Row(
                        name: l10n.accountWishlistRow,
                        value: l10n.accountWishlistValue(items.length.toString()),
                        onTap: widget.onOpenWishlist,
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
                        onTap: widget.onOpenWallet,
                      );
                    },
                  ),
                  _Row(name: l10n.addressesTitle, onTap: widget.onOpenAddresses),
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
                onTap: widget.onBecomeSeller,
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

class _ProfileHeader extends StatelessWidget {
  final UserProfile? profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = this.profile;
    final name = profile?.name;
    final hasName = name != null && name.trim().isNotEmpty;
    final title = hasName ? name : (profile?.phone ?? '');

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: profile == null ? null : () => _showEditNameSheet(context, name ?? ''),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.tealBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: hasName
                ? Text(
                    name.characters.first.toUpperCase(),
                    style: AppTextStyles.h1.copyWith(fontSize: 20, color: AppColors.teal),
                  )
                : const Icon(Icons.person_outline_rounded, color: AppColors.teal),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3, textDirection: hasName ? null : TextDirection.ltr),
                if (profile != null)
                  Text(
                    hasName
                        ? l10n.accountMemberSince(profile.createdAt.year.toString(), _emirateLabel(l10n, profile.emirate))
                        : l10n.accountAddNamePrompt,
                    style: AppTextStyles.caption.copyWith(fontSize: 11.5),
                  ),
              ],
            ),
          ),
          if (profile != null) const Icon(Icons.edit_outlined, size: 18, color: Color(0xFFC9C0B0)),
        ],
      ),
    );
  }

  /// Maps the backend's `AuthEmirate` enum value to its UI label.
  static String _emirateLabel(AppLocalizations l10n, String emirate) {
    switch (emirate) {
      case 'DUBAI':
        return l10n.emirateDubai;
      case 'ABU_DHABI':
        return l10n.emirateAbuDhabi;
      case 'SHARJAH':
        return l10n.emirateSharjah;
      default:
        return l10n.emirateOther;
    }
  }

  Future<void> _showEditNameSheet(BuildContext context, String currentName) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _EditNameSheet(initialName: currentName),
    );
  }
}

class _EditNameSheet extends StatefulWidget {
  final String initialName;

  const _EditNameSheet({required this.initialName});

  @override
  State<_EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<_EditNameSheet> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialName);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final error = await sl<AccountCubit>().updateName(name);
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 18 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.accountEditNameTitle, style: AppTextStyles.h3),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(hintText: l10n.accountNameHint, errorText: _error),
          ),
          const SizedBox(height: 14),
          PrimaryButton(label: l10n.accountSaveCta, onPressed: _saving ? null : _save, loading: _saving),
        ],
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
