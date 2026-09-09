import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/market_event.dart';

/// One pop-up market a seller can reserve a booth at — the venue/emirate
/// ("the place") plus a reserve/cancel action driven by [SellerCubit].
class MarketEventCard extends StatelessWidget {
  final MarketEvent event;
  final bool reserved;
  final VoidCallback onReserve;
  final VoidCallback onCancel;

  const MarketEventCard({
    super.key,
    required this.event,
    required this.reserved,
    required this.onReserve,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);
    final full = event.slotsLeft <= 0 && !reserved;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: reserved ? AppColors.teal : AppColors.border, width: reserved ? 1.5 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              FadeInNetworkImage(
                url: event.imageUrl,
                width: double.infinity,
                height: 120,
                fallback: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: event.fallbackGradient,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 10,
                start: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration:
                      BoxDecoration(color: AppColors.card.withOpacity(0.92), borderRadius: BorderRadius.circular(999)),
                  child: Text(event.dateLabel.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11)),
                ),
              ),
              if (reserved)
                PositionedDirectional(
                  top: 10,
                  end: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(999)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded, size: 12, color: AppColors.card),
                        const SizedBox(width: 4),
                        Text(l10n.sellerReservedLabel,
                            style: AppTextStyles.caption.copyWith(color: AppColors.card, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name.resolve(locale), style: AppTextStyles.h3.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${event.venue.resolve(locale)} · ${event.emirate.resolve(locale)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMuted.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  full ? l10n.sellerSlotsFull : l10n.sellerSlotsLeft(event.slotsLeft.toString()),
                  style: AppTextStyles.caption.copyWith(color: full ? AppColors.error : AppColors.teal, fontSize: 11.5),
                ),
                const SizedBox(height: 10),
                if (reserved)
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      backgroundColor: AppColors.card,
                      side: const BorderSide(color: AppColors.border, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.sellerCancelReservationCta,
                        style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.error)),
                  )
                else
                  PrimaryButton(label: l10n.sellerReserveCta, onPressed: full ? null : onReserve),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
