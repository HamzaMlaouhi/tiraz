import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// The pill-shaped selectable chip used for emirates, sizes, and
/// measurement-profile picks across the design.
class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool pill;

  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.pill = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.tealBg : AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(pill ? 999 : 10),
        side: BorderSide(color: selected ? AppColors.teal : AppColors.border, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(pill ? 999 : 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pill ? 15 : 16, vertical: 8),
          child: Text(
            label,
            style: AppTextStyles.chip.copyWith(
              color: selected ? AppColors.tealDark : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
