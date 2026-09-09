import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

typedef NavTab = ({IconData icon, IconData activeIcon, String label});

/// The buyer-side bottom-tab set. Kept alongside [sellerNavTabs] so the
/// router can hand either to the same [AppShell].
List<NavTab> buyerNavTabs(AppLocalizations l10n) => [
      (icon: Icons.storefront_outlined, activeIcon: Icons.storefront, label: l10n.navHome),
      (icon: Icons.content_cut_outlined, activeIcon: Icons.content_cut, label: l10n.navMyFit),
      (icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: l10n.navOrders),
      (icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n.navAccount),
    ];

/// The seller-side bottom-tab set — dashboard, listings, market-event
/// reservations, account — in place of the buyer's shop/fit/orders/account.
List<NavTab> sellerNavTabs(AppLocalizations l10n) => [
      (icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: l10n.navSellerHome),
      (icon: Icons.checkroom_outlined, activeIcon: Icons.checkroom, label: l10n.navSellerProducts),
      (icon: Icons.event_outlined, activeIcon: Icons.event, label: l10n.navSellerEvents),
      (icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n.navAccount),
    ];

/// Bottom-tab chrome, wired to a [StatefulShellRoute] so each tab keeps
/// its own navigation stack (e.g. Home -> Product) while switching tabs.
/// [tabs] is supplied by the router — buyer and seller each get their own
/// [StatefulShellRoute] with a different tab set, sharing this one widget.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<NavTab> tabs;

  const AppShell({super.key, required this.navigationShell, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xF7FAF7F2),
          border: Border(top: BorderSide(color: AppColors.borderAlt)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: List.generate(tabs.length, (i) {
                final selected = i == navigationShell.currentIndex;
                final tab = tabs[i];
                return Expanded(
                  child: InkWell(
                    onTap: () => navigationShell.goBranch(i, initialLocation: i == navigationShell.currentIndex),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selected ? tab.activeIcon : tab.icon,
                            size: 20,
                            color: selected ? AppColors.teal : const Color(0xFFA39A8B),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            tab.label,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10,
                              color: selected ? AppColors.teal : const Color(0xFFA39A8B),
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
