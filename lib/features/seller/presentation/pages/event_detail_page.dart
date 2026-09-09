import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../domain/entities/market_event.dart';
import '../cubit/seller_cubit.dart';

/// The full profile of one market event — a bigger photo of the venue,
/// date/time/place, whether it's free or paid to join, expected
/// attendance, and the reserve/cancel action.
class EventDetailPage extends StatelessWidget {
  final String eventId;
  final VoidCallback onBack;

  const EventDetailPage({super.key, required this.eventId, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          bloc: sl<SellerCubit>(),
          builder: (context, state) {
            MarketEvent? event;
            for (final e in state.events) {
              if (e.id == eventId) {
                event = e;
                break;
              }
            }

            if (event == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: onBack, child: Text(l10n.retry)),
                  ],
                ),
              );
            }

            final reserved = state.reservedEventIds.contains(event.id);
            final full = event.slotsLeft <= 0 && !reserved;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                    child: RoundIconButton.back(onPressed: onBack),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FadeInNetworkImage(
                        url: event.imageUrl,
                        width: double.infinity,
                        height: 220,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.name.resolve(locale), style: AppTextStyles.h1),
                        const SizedBox(height: 12),
                        _InfoRow(icon: Icons.calendar_today_outlined, text: event.dateLabel.resolve(locale)),
                        const SizedBox(height: 8),
                        _InfoRow(icon: Icons.access_time_rounded, text: event.timeLabel.resolve(locale)),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          text: '${event.venue.resolve(locale)} · ${event.emirate.resolve(locale)}',
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.payments_outlined,
                                label: l10n.sellerEventFeeLabel,
                                value:
                                    event.isFree ? l10n.sellerEventFreeLabel : formatAed(event.feeAed.round(), locale),
                                valueColor: event.isFree ? AppColors.teal : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.groups_outlined,
                                label: l10n.sellerEventAttendeesLabel,
                                value:
                                    l10n.sellerEventAttendeesCount(NumberFormat('#,##0').format(event.attendeeCount)),
                                valueColor: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: full ? AppColors.error.withOpacity(0.08) : AppColors.tealBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            full ? l10n.sellerSlotsFull : l10n.sellerSlotsLeft(event.slotsLeft.toString()),
                            style: AppTextStyles.label.copyWith(
                              color: full ? AppColors.error : AppColors.tealDark,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (reserved)
                          OutlinedButton(
                            onPressed: () => sl<SellerCubit>().cancelReservation(event!.id),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: AppColors.card,
                              side: const BorderSide(color: AppColors.border, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                            ),
                            child: Text(
                              l10n.sellerCancelReservationCta,
                              style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.error),
                            ),
                          )
                        else
                          PrimaryButton(
                            label: l10n.sellerReserveCta,
                            onPressed: full ? null : () => sl<SellerCubit>().reserveEvent(event!.id),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.body.copyWith(fontSize: 13, height: 1.3))),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({required this.icon, required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.teal),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.label.copyWith(fontSize: 13, color: valueColor)),
        ],
      ),
    );
  }
}
