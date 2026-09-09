import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/seller_cubit.dart';
import '../widgets/market_event_card.dart';

/// Market events a seller can reserve a booth at — "your reservations"
/// up top (with the venue/emirate for each), the full catalog below.
class SellerEventsPage extends StatelessWidget {
  final void Function(String eventId) onOpenEventDetail;

  const SellerEventsPage({super.key, required this.onOpenEventDetail});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          bloc: sl<SellerCubit>(),
          builder: (context, state) {
            final reserved = state.events.where((e) => state.reservedEventIds.contains(e.id)).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Text(l10n.sellerEventsTitle, style: AppTextStyles.h1),
                const SizedBox(height: 4),
                Text(l10n.sellerEventsSubtitle, style: AppTextStyles.bodyMuted),
                const SizedBox(height: 20),
                Text(l10n.sellerYourReservationsTitle, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 12),
                if (reserved.isEmpty)
                  Text(l10n.sellerNoReservations, style: AppTextStyles.bodyMuted)
                else
                  ...reserved.map((event) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MarketEventCard(
                          event: event,
                          reserved: true,
                          onTap: () => onOpenEventDetail(event.id),
                          onReserve: () {},
                          onCancel: () => sl<SellerCubit>().cancelReservation(event.id),
                        ),
                      )),
                const Divider(height: 32),
                ...state.events.map((event) {
                  final isReserved = state.reservedEventIds.contains(event.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MarketEventCard(
                      event: event,
                      reserved: isReserved,
                      onTap: () => onOpenEventDetail(event.id),
                      onReserve: () => sl<SellerCubit>().reserveEvent(event.id),
                      onCancel: () => sl<SellerCubit>().cancelReservation(event.id),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
