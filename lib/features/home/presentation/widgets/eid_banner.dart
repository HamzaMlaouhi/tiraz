import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_network_image.dart';

class EidBanner extends StatelessWidget {
  final int daysAway;

  const EidBanner({super.key, required this.daysAway});

  static const _imageUrl = 'https://picsum.photos/seed/tiraz-eid-hero/800/440';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 190,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const FadeInNetworkImage(
              url: _imageUrl,
              fit: BoxFit.cover,
              fallback: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF3EAD9), Color(0xFFECE0C8), Color(0xFFEFE2C9), Color(0xFFF3EAD9)],
                  ),
                ),
              ),
            ),
            // A warm, sand-toned scrim keeps the Eid brand feel and text
            // legibility over any photo — real or the fallback gradient.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xE6241C10), Color(0x992A2117), Color(0x40000000)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.eidTitle(daysAway.toString()), style: AppTextStyles.h3.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(l10n.eidSubtitle,
                      style: AppTextStyles.body.copyWith(fontSize: 12, color: const Color(0xFFF0E9DC))),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(999)),
                    child:
                        Text(l10n.eidChip, style: AppTextStyles.chip.copyWith(color: AppColors.card, fontSize: 11.5)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
