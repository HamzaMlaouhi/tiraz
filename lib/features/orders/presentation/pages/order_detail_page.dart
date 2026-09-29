import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/orders_cubit.dart';
import '../widgets/timeline_row.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  final VoidCallback onBack;

  const OrderDetailPage({super.key, required this.orderId, required this.onBack});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  // Always re-fetch: the list copy may be stale (timeline stages move on
  // the server), and a deep link may arrive before the list has loaded.
  Future<void> _refresh() async {
    setState(() => _loadError = null);
    final error = await sl<OrdersCubit>().loadOne(widget.orderId);
    if (mounted) setState(() => _loadError = error);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          bloc: sl<OrdersCubit>(),
          builder: (context, state) {
            final order = state.byId(widget.orderId);
            if (order == null) {
              if (_loadError == null) {
                return const Center(child: CircularProgressIndicator(color: AppColors.teal));
              }
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: _refresh, child: Text(l10n.retry)),
                  ],
                ),
              );
            }
            final justPlaced = state.justPlacedOrderId == widget.orderId;

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Row(
                  children: [
                    RoundIconButton.back(onPressed: widget.onBack),
                    const SizedBox(width: 10),
                    Text(l10n.orderDetailTitle, style: AppTextStyles.h2),
                  ],
                ),
                if (justPlaced) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      l10n.orderPlacedBanner,
                      style: AppTextStyles.label.copyWith(color: AppColors.tealDark, fontSize: 12.5),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: order.imageGradient),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.itemName.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                                const SizedBox(height: 2),
                                Text(order.sellerMeta.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.tealBg, borderRadius: BorderRadius.circular(999)),
                            child: Text(
                              order.etaLabel.resolve(locale),
                              style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.tealDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: List.generate(
                          order.timeline.length,
                          (i) => TimelineRow(step: order.timeline[i], isLast: i == order.timeline.length - 1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.card,
                                side: const BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(l10n.orderChatCta, style: AppTextStyles.buttonSecondary.copyWith(fontSize: 12.5)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.card,
                                side: const BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(l10n.orderTrackCta, style: AppTextStyles.buttonSecondary.copyWith(fontSize: 12.5)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(color: AppColors.sandBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(l10n.orderGuarantee, style: AppTextStyles.bodyMuted.copyWith(color: AppColors.sandText, fontSize: 11.5)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
