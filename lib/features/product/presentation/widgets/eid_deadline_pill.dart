import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/eid_deadline.dart';

/// "Order by Feb 25 to receive before Eid" under the RTW/MTM tabs: festive
/// sand while there's time, gold in the last week, muted once it's too late.
class EidDeadlinePill extends StatelessWidget {
  final EidDeadline deadline;

  const EidDeadlinePill({super.key, required this.deadline});

  @override
  Widget build(BuildContext context) {
    final (background, border, foreground, icon) = switch (deadline.status) {
      EidDeadlineStatus.open => (AppColors.sandBg, AppColors.sandBg, AppColors.sandTextDark, Icons.nightlight_round),
      EidDeadlineStatus.closingSoon => (AppColors.sandBg, AppColors.gold, AppColors.sandTextDark, Icons.schedule_rounded),
      EidDeadlineStatus.closed => (AppColors.surface, AppColors.border, AppColors.textMuted, Icons.event_busy_outlined),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              deadline.label.of(context),
              style: AppTextStyles.label.copyWith(fontSize: 12.5, color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
