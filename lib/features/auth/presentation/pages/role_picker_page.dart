import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/role/role_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';

/// The very first choice after splash: shop, or sell. Drives which shell
/// (and home page) the rest of the session lands on — switchable later
/// from either side's account tab, so nothing here is a one-way door.
class RolePickerPage extends StatefulWidget {
  const RolePickerPage({super.key});

  @override
  State<RolePickerPage> createState() => _RolePickerPageState();
}

class _RolePickerPageState extends State<RolePickerPage> {
  UserRole? _selected;

  void _continue() {
    final role = _selected;
    if (role == null) return;
    sl<RoleCubit>().choose(role);
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(l10n.appName, style: AppTextStyles.h2.copyWith(fontSize: 26, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(l10n.appNameLatin,
                        style: AppTextStyles.wordmarkLatin.copyWith(fontSize: 10, letterSpacing: 4)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(l10n.roleTitle, style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(l10n.roleSubtitle, style: AppTextStyles.bodyMuted),
              const SizedBox(height: 24),
              _RoleCard(
                icon: Icons.shopping_bag_outlined,
                title: l10n.roleBuyerTitle,
                subtitle: l10n.roleBuyerSubtitle,
                selected: _selected == UserRole.buyer,
                onTap: () => setState(() => _selected = UserRole.buyer),
              ),
              const SizedBox(height: 12),
              _RoleCard(
                icon: Icons.storefront_outlined,
                title: l10n.roleSellerTitle,
                subtitle: l10n.roleSellerSubtitle,
                selected: _selected == UserRole.seller,
                onTap: () => setState(() => _selected = UserRole.seller),
              ),
              const Spacer(),
              PrimaryButton(label: l10n.roleContinueCta, onPressed: _selected == null ? null : _continue),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? AppColors.tealBg : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.teal : AppColors.tealBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 20, color: selected ? AppColors.card : AppColors.teal),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.label.copyWith(fontSize: 15)),
                      const SizedBox(height: 3),
                      Text(subtitle, style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  size: 22,
                  color: selected ? AppColors.teal : const Color(0xFFC9C0B0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
