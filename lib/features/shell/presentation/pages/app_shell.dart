import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Bottom-tab chrome, wired to a [StatefulShellRoute] so each tab keeps
/// its own navigation stack (e.g. Home -> Product) while switching tabs.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabs = [
      (icon: Icons.storefront_outlined, activeIcon: Icons.storefront, label: l10n.navHome),
      (icon: Icons.content_cut_outlined, activeIcon: Icons.content_cut, label: l10n.navMyFit),
      (icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: l10n.navOrders),
      (icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l10n.navAccount),
    ];

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
