import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/fit_zone.dart';

class FitZoneBar extends StatelessWidget {
  final FitZone zone;

  const FitZoneBar({super.key, required this.zone});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 64, child: Text(zone.name.resolve(locale), style: AppTextStyles.bodyMuted.copyWith(height: 1))),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: zone.fitFraction,
                minHeight: 6,
                backgroundColor: const Color(0xFFEFE9DD),
                valueColor: const AlwaysStoppedAnimation(AppColors.teal),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 56,
            child: Text(
              zone.label.resolve(locale),
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
