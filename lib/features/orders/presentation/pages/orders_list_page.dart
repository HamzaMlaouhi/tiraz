import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/orders_cubit.dart';
import '../widgets/order_card.dart';

class OrdersListPage extends StatelessWidget {
  final void Function(String orderId) onOpenOrder;

  const OrdersListPage({super.key, required this.onOpenOrder});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          bloc: sl<OrdersCubit>(),
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.teal));
            }
            if (state.status == OrdersStatus.error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: () => sl<OrdersCubit>().load(), child: Text(l10n.retry)),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Text(l10n.navOrders, style: AppTextStyles.h2),
                const SizedBox(height: 16),
                ...state.orders.map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OrderCard(order: order, onTap: () => onOpenOrder(order.id)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
