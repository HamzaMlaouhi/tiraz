import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../cubit/wishlist_cubit.dart';
import '../../domain/entities/wishlist_item.dart';

class WishlistPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onBrowse;

  const WishlistPage({super.key, required this.onBack, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WishlistCubit, List<WishlistItem>>(
          bloc: sl<WishlistCubit>(),
          builder: (context, items) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Row(
                  children: [
                    RoundIconButton.back(onPressed: onBack),
                    const SizedBox(width: 10),
                    Text(l10n.wishlistTitle, style: AppTextStyles.h2),
                  ],
                ),
                if (items.isEmpty) ...[
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Text(l10n.wishlistEmptyMessage, textAlign: TextAlign.center, style: AppTextStyles.bodyMuted.copyWith(height: 1.6)),
                      const SizedBox(height: 14),
                      ElevatedButton(onPressed: onBrowse, child: Text(l10n.browseDesigns, style: AppTextStyles.buttonPrimary)),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                    children: items.map((item) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(colors: item.imageGradient),
                                  ),
                                ),
                                PositionedDirectional(
                                  top: 7,
                                  end: 7,
                                  child: Material(
                                    color: AppColors.card.withOpacity(0.92),
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () => sl<WishlistCubit>().remove(item.id),
                                      child: const SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: Icon(Icons.favorite, size: 13, color: AppColors.teal),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(item.name.resolve(locale), style: AppTextStyles.label.copyWith(fontSize: 12.5)),
                          Text(item.seller.resolve(locale), style: AppTextStyles.caption.copyWith(fontSize: 11)),
                          Text(formatAed(item.priceAed, locale), style: AppTextStyles.priceSmall),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
