import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/icon_utils.dart';

/// The circular back/action button used throughout the design
/// (rendered as `←`/`→` glyphs there; a proper directional icon here).
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const RoundIconButton({super.key, required this.icon, required this.onPressed});

  factory RoundIconButton.back({required VoidCallback? onPressed}) =>
      RoundIconButton(icon: Icons.arrow_back_ios_new_rounded, onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border, width: 1)),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: MirroredIcon(icon, size: 15, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
