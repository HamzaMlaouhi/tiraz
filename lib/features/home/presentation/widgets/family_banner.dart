import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../../core/widgets/fade_in_network_image.dart';

class FamilyBanner extends StatelessWidget {
  final VoidCallback onTap;

  const FamilyBanner({super.key, required this.onTap});

  static const _imageUrl = 'https://picsum.photos/seed/tiraz-family-set/160/160';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.tealBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const FadeInNetworkImage(
                  url: _imageUrl,
                  width: 52,
                  height: 52,
                  fallback: DecoratedBox(decoration: BoxDecoration(color: AppColors.tealMuted)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.familySetsTitle, style: AppTextStyles.label.copyWith(color: AppColors.tealDark)),
                    const SizedBox(height: 3),
                    Text(l10n.familySetsSubtitle,
                        style: AppTextStyles.caption.copyWith(color: AppColors.tealMuted, fontSize: 11.5)),
                  ],
                ),
              ),
              const MirroredIcon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.teal),
            ],
          ),
        ),
      ),
    );
  }
}
