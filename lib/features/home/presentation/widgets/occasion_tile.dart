import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../domain/entities/occasion.dart';

class OccasionTile extends StatelessWidget {
  final Occasion occasion;

  const OccasionTile({super.key, required this.occasion});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FadeInNetworkImage(
            url: occasion.imageUrl,
            fit: BoxFit.cover,
            fallback: DecoratedBox(decoration: BoxDecoration(color: occasion.background)),
          ),
          // A bottom scrim keeps the label legible over any photo — real
          // or the flat-color fallback alike.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x9E1A1610)],
                stops: [0.35, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  occasion.name.resolve(locale),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  occasion.itemCount.resolve(locale),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: const Color(0xFFEDE8DE)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
