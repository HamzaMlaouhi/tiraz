import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Stands in for My Fit / Orders / Account until those features are
/// built out in a follow-up pass.
class ComingSoonPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const ComingSoonPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Align(alignment: AlignmentDirectional.centerStart, child: Text(title, style: AppTextStyles.h1)),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 40, color: AppColors.textMuted),
                    const SizedBox(height: 14),
                    Text(l10n.comingSoon, style: AppTextStyles.h3),
                    const SizedBox(height: 6),
                    Text(l10n.comingSoonBody, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
