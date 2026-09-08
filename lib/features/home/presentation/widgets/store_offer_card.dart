import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../domain/entities/store.dart';

/// A promotional tile for the "Offers for you" rail — the store's banner
/// photo full-bleed, with the deal copy pinned over a bottom scrim. Doesn't
/// carry a [Hero] tag of its own: the same store's [StoreCard] elsewhere on
/// the feed already owns that tag, and both can be on screen at once.
class StoreOfferCard extends StatelessWidget {
  final Store store;
  final VoidCallback onTap;

  const StoreOfferCard({super.key, required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final offer = store.offer;
    if (offer == null) return const SizedBox.shrink();

    return PressScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 240,
          height: 130,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeInNetworkImage(
                url: store.bannerImageUrl,
                fit: BoxFit.cover,
                fallback: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: store.fallbackGradient,
                    ),
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB0181410)],
                    stops: [0.3, 1],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.resolve(locale),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label.copyWith(color: Colors.white, fontSize: 13.5),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            store.name.resolve(locale),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(color: const Color(0xFFEDE8DE), fontSize: 11),
                          ),
                        ),
                        const MirroredIcon(Icons.arrow_forward_ios_rounded, size: 11, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
