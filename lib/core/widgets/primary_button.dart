import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/icon_utils.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  /// Optional trailing flourish (e.g. a forward arrow on a CTA). Placed
  /// after the label in the Row — lands on the reading-direction side
  /// automatically under RTL — and rendered via [MirroredIcon] so the
  /// glyph itself points the right way too.
  final IconData? icon;

  const PrimaryButton({super.key, required this.label, required this.onPressed, this.loading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    // buttonPrimary hardcodes white, which reads fine on the enabled
    // teal/burgundy fill but goes near-invisible on the theme's disabled
    // fill (a light tint) — so, unlike most of this label's other uses,
    // the disabled case needs its own color rather than inheriting the
    // button's disabledForegroundColor (a hardcoded TextStyle color wins
    // over that regardless).
    final disabled = onPressed == null && !loading;
    final fgColor = disabled ? AppColors.tealMuted.withOpacity(0.6) : AppColors.card;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.card),
              )
            : icon == null
                ? Text(label, style: AppTextStyles.buttonPrimary.copyWith(color: fgColor))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label, style: AppTextStyles.buttonPrimary.copyWith(color: fgColor)),
                      const SizedBox(width: 10),
                      MirroredIcon(icon!, size: 18, color: fgColor),
                    ],
                  ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.card,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        ),
        child: Text(label, style: AppTextStyles.buttonSecondary),
      ),
    );
  }
}

class TextLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const TextLinkButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: AppColors.teal),
      child: Text(
        label,
        style: AppTextStyles.buttonSecondary.copyWith(
          color: AppColors.teal,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.teal,
        ),
      ),
    );
  }
}
