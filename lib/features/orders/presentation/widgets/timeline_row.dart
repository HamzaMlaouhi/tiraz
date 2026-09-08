import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order_timeline_step.dart';

class TimelineRow extends StatelessWidget {
  final OrderTimelineStep step;
  final bool isLast;

  const TimelineRow({super.key, required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final done = step.stage == TimelineStage.done;
    final now = step.stage == TimelineStage.now;

    final dotBg = done ? AppColors.teal : (now ? AppColors.card : const Color(0xFFEFE9DD));
    final dotBorder = done || now ? AppColors.teal : const Color(0xFFE0D8C8);
    final textColor = step.stage == TimelineStage.pending ? AppColors.textMuted : AppColors.textPrimary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(color: dotBg, shape: BoxShape.circle, border: Border.all(color: dotBorder, width: 2)),
                alignment: Alignment.center,
                child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, constraints: const BoxConstraints(minHeight: 26), color: done ? AppColors.teal : const Color(0xFFE0D8C8)),
                ),
            ],
          ),
          const SizedBox(width: 13),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.name.resolve(locale),
                  style: AppTextStyles.label.copyWith(fontSize: 13, color: textColor, fontWeight: now ? FontWeight.w700 : FontWeight.w600),
                ),
                Text(step.sub.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
