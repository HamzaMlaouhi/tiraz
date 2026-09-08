import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/product_cubit.dart';

class ModeTabs extends StatelessWidget {
  final ProductMode mode;
  final ValueChanged<ProductMode> onChanged;

  const ModeTabs({super.key, required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFEFE9DD), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(child: _tab(l10n.readyToWear, ProductMode.readyToWear)),
          Expanded(child: _tab(l10n.madeToMeasure, ProductMode.madeToMeasure)),
        ],
      ),
    );
  }

  Widget _tab(String label, ProductMode value) {
    final selected = mode == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected ? [const BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.chip.copyWith(
            fontSize: 13,
            color: selected
                ? (value == ProductMode.madeToMeasure ? AppColors.teal : AppColors.textPrimary)
                : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
