import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Stand-in for the design's `<image-slot>` — a placeholder box for
/// product photography that isn't wired to real assets yet.
class ImageSlot extends StatelessWidget {
  final String placeholder;
  final Gradient? gradient;
  final BorderRadius borderRadius;

  const ImageSlot({
    super.key,
    required this.placeholder,
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: gradient == null ? AppColors.occasionSand : null,
          gradient: gradient,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Text(
          placeholder,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
