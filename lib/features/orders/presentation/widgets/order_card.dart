import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);
    final delivered = order.status == OrderStatusKind.delivered;

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
          child: Row(
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
                    Text(order.date.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: delivered ? const Color(0xFFEFE9DD) : AppColors.tealBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  delivered ? l10n.orderStatusDelivered : l10n.orderStatusInProduction,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    color: delivered ? AppColors.textMuted : AppColors.tealDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
