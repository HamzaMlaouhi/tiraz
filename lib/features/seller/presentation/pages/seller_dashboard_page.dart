import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dotted_add_button.dart';
import '../../../../core/widgets/fade_in_network_image.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/seller_store_profile.dart';
import '../cubit/seller_cubit.dart';
import '../widgets/market_event_card.dart';
import '../widgets/seller_product_tile.dart';

/// The seller-side home page: a snapshot of "your store", a preview of
/// your listings, and the market events you might reserve a spot at.
class SellerDashboardPage extends StatelessWidget {
  final VoidCallback onOpenProducts;
  final VoidCallback onOpenEvents;
  final VoidCallback onAddProduct;
  final void Function(String eventId) onOpenEventDetail;
  final void Function(String productId) onOpenProductDetail;

  const SellerDashboardPage({
    super.key,
    required this.onOpenProducts,
    required this.onOpenEvents,
    required this.onAddProduct,
    required this.onOpenEventDetail,
    required this.onOpenProductDetail,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          bloc: sl<SellerCubit>(),
          builder: (context, state) {
            final previewProducts = state.products.take(4).toList();
            final previewEvents = state.events.take(2).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Text(l10n.sellerDashboardTitle, style: AppTextStyles.h1),
                const SizedBox(height: 16),
                FadeSlideIn(child: _StoreHero(store: state.store)),
                const SizedBox(height: 24),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: _SectionHeader(
                      title: l10n.sellerProductsPreviewTitle, seeAllLabel: l10n.seeAllCta, onSeeAll: onOpenProducts),
                ),
                const SizedBox(height: 12),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 130),
                  child: previewProducts.isEmpty
                      ? GestureDetector(onTap: onAddProduct, child: DottedAddButton(label: l10n.sellerAddProductCta))
                      : SizedBox(
                          height: 256,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: previewProducts.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final p = previewProducts[i];
                              return SellerProductTile(
                                product: p,
                                onTap: () => onOpenProductDetail(p.id),
                                onRemove: () => sl<SellerCubit>().removeProduct(p.id),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 180),
                  child: _SectionHeader(
                      title: l10n.sellerEventsPreviewTitle, seeAllLabel: l10n.seeAllCta, onSeeAll: onOpenEvents),
                ),
                const SizedBox(height: 12),
                ...List.generate(previewEvents.length, (i) {
                  final event = previewEvents[i];
                  final reserved = state.reservedEventIds.contains(event.id);
                  return FadeSlideIn(
                    delay: Duration(milliseconds: 230 + i * 70),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: i == previewEvents.length - 1 ? 0 : 12),
                      child: MarketEventCard(
                        event: event,
                        reserved: reserved,
                        onTap: () => onOpenEventDetail(event.id),
                        onReserve: () => sl<SellerCubit>().reserveEvent(event.id),
                        onCancel: () => sl<SellerCubit>().cancelReservation(event.id),
                      ),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String seeAllLabel;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.seeAllLabel, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(seeAllLabel, style: AppTextStyles.label.copyWith(color: AppColors.teal, fontSize: 12.5)),
        ),
      ],
    );
  }
}

class _StoreHero extends StatelessWidget {
  final SellerStoreProfile store;

  const _StoreHero({required this.store});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              FadeInNetworkImage(
                url: store.bannerImageUrl,
                width: double.infinity,
                height: 110,
                fallback: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight, colors: store.fallbackGradient),
                  ),
                ),
              ),
              PositionedDirectional(
                start: 14,
                bottom: -22,
                child: Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                  child: ClipOval(
                    child: FadeInNetworkImage(
                      url: store.logoImageUrl,
                      width: 46,
                      height: 46,
                      fallback: const DecoratedBox(decoration: BoxDecoration(color: AppColors.tealBg)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 30, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sellerYourStoreLabel.toUpperCase(),
                  style:
                      AppTextStyles.caption.copyWith(fontSize: 10, letterSpacing: 0.6, color: AppColors.textMutedAlt),
                ),
                const SizedBox(height: 3),
                Text(store.name.resolve(locale), style: AppTextStyles.h3),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(store.emirate.resolve(locale), style: AppTextStyles.bodyMuted.copyWith(fontSize: 12.5)),
                    const SizedBox(width: 12),
                    const Icon(Icons.star_rounded, size: 15, color: Color(0xFFD9A441)),
                    const SizedBox(width: 3),
                    Text(
                      l10n.ratingLabel(store.rating.toStringAsFixed(1), '${store.reviewCount}'),
                      style: AppTextStyles.bodyMuted.copyWith(fontSize: 12.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
