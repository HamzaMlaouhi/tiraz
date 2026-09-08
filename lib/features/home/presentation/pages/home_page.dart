import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/entities/product_summary.dart';
import '../../domain/entities/store.dart';
import '../cubit/home_cubit.dart';
import '../widgets/drop_card.dart';
import '../widgets/eid_banner.dart';
import '../widgets/family_banner.dart';
import '../widgets/home_loading_skeleton.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/occasion_tile.dart';
import '../widgets/store_card.dart';
import '../widgets/store_offer_card.dart';
import '../widgets/store_sheet.dart';

class HomePage extends StatelessWidget {
  final void Function(String productId) onOpenProduct;
  final VoidCallback onOpenFamilySets;
  final VoidCallback onOpenCart;

  const HomePage({super.key, required this.onOpenProduct, required this.onOpenFamilySets, required this.onOpenCart});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => sl<HomeCubit>()..load(),
      child: _HomeView(onOpenProduct: onOpenProduct, onOpenFamilySets: onOpenFamilySets, onOpenCart: onOpenCart),
    );
  }
}

class _HomeView extends StatefulWidget {
  final void Function(String productId) onOpenProduct;
  final VoidCallback onOpenFamilySets;
  final VoidCallback onOpenCart;

  const _HomeView({required this.onOpenProduct, required this.onOpenFamilySets, required this.onOpenCart});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  String _query = '';

  void _openStore(BuildContext context, Store store) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StoreSheet(store: store, onOpenProduct: widget.onOpenProduct),
    );
  }

  static bool _matches(LocalizedText text, String query) =>
      text.ar.toLowerCase().contains(query) || text.en.toLowerCase().contains(query);

  List<Store> _matchingStores(HomeData data, String query) =>
      data.stores.where((s) => _matches(s.name, query) || _matches(s.emirate, query)).toList();

  List<ProductSummary> _matchingProducts(HomeData data, String query) {
    // New drops and every store's preview overlap (the same piece can
    // appear in both) — dedupe by id before filtering.
    final byId = <String, ProductSummary>{};
    for (final p in [...data.newDrops, ...data.stores.expand((s) => s.products)]) {
      byId[p.id] = p;
    }
    return byId.values.where((p) => _matches(p.name, query) || _matches(p.seller, query)).toList();
  }

  Widget _buildSearchResults(BuildContext context, HomeData data) {
    final l10n = AppLocalizations.of(context);
    final query = _query.trim().toLowerCase();
    final stores = _matchingStores(data, query);
    final products = _matchingProducts(data, query);

    if (stores.isEmpty && products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 56),
        child: Center(
          child: Text(l10n.searchNoResults(_query.trim()), style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (stores.isNotEmpty) ...[
          Text(l10n.searchSectionStores, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stores.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final store = stores[i];
                return StoreCard(store: store, onTap: () => _openStore(context, store));
              },
            ),
          ),
          const SizedBox(height: 22),
        ],
        if (products.isNotEmpty) ...[
          Text(l10n.searchSectionProducts, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 16,
            children: products.map((p) => DropCard(product: p, onTap: () => widget.onOpenProduct(p.id))).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildBrowseContent(BuildContext context, HomeData data, int crossAxisCount) {
    final l10n = AppLocalizations.of(context);
    final offerStores = data.stores.where((s) => s.offer != null).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeSlideIn(child: EidBanner(daysAway: data.eidDaysAway)),
        if (offerStores.isNotEmpty) ...[
          const SizedBox(height: 22),
          FadeSlideIn(
            delay: const Duration(milliseconds: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.offersTitle, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 2),
                Text(l10n.offersSubtitle, style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 130,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: offerStores.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final store = offerStores[i];
                      return StoreOfferCard(store: store, onTap: () => _openStore(context, store));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 22),
        FadeSlideIn(
          delay: const Duration(milliseconds: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.storesTitle, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 2),
              Text(l10n.storesSubtitle, style: AppTextStyles.bodyMuted.copyWith(fontSize: 12)),
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.stores.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final store = data.stores[i];
                    return StoreCard(store: store, onTap: () => _openStore(context, store));
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        FadeSlideIn(
          delay: const Duration(milliseconds: 210),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.shopByOccasion, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 150 / 88,
                children: data.occasions.map((o) => OccasionTile(occasion: o)).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        FadeSlideIn(
          delay: const Duration(milliseconds: 280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.newFromDesigners, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 12),
              // Fixed, not screen-relative: DropCard's content (a 190px
              // image plus three text lines) doesn't scale with the
              // viewport, so a percentage-of-height box could clip it on
              // shorter screens.
              SizedBox(
                height: 256,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.newDrops.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final drop = data.newDrops[i];
                    return DropCard(product: drop, onTap: () => widget.onOpenProduct(drop.id));
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        FadeSlideIn(
          delay: const Duration(milliseconds: 350),
          child: FamilyBanner(onTap: widget.onOpenFamilySets),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Breakpoints keep the feed readable from a small phone up through a
    // tablet/foldable/web window: more grid columns and breathing room as
    // width grows, and a capped content width so it doesn't stretch edge
    // to edge on very wide screens.
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;
    final isWide = width >= 900;
    final crossAxisCount = isWide ? 4 : (isTablet ? 3 : 2);
    final horizontalPadding = isWide ? 32.0 : (isTablet ? 24.0 : 18.0);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().load(),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                    child: Text(l10n.appName,
                                        style: AppTextStyles.wordmarkSmall, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    l10n.appNameLatin,
                                    style: AppTextStyles.wordmarkLatin.copyWith(fontSize: 11, letterSpacing: 3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          BlocBuilder<CartCubit, CartState>(
                            bloc: sl<CartCubit>(),
                            builder: (context, cartState) {
                              final cartCount = cartState.itemCount;
                              return Material(
                                color: AppColors.card,
                                shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: widget.onOpenCart,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        const Center(
                                            child: Icon(Icons.shopping_bag_outlined,
                                                size: 18, color: AppColors.textPrimary)),
                                        PositionedDirectional(
                                          top: -2,
                                          end: -2,
                                          child: AnimatedScale(
                                            scale: cartCount > 0 ? 1 : 0,
                                            duration: const Duration(milliseconds: 220),
                                            curve: Curves.easeOutBack,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                              constraints: const BoxConstraints(minWidth: 17),
                                              decoration: BoxDecoration(
                                                  color: AppColors.teal, borderRadius: BorderRadius.circular(999)),
                                              child: AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 180),
                                                transitionBuilder: (child, anim) =>
                                                    ScaleTransition(scale: anim, child: child),
                                                child: Text(
                                                  '$cartCount',
                                                  key: ValueKey(cartCount),
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.caption
                                                      .copyWith(color: AppColors.card, fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 0),
                    sliver: SliverToBoxAdapter(
                      child: HomeSearchBar(onChanged: (q) => setState(() => _query = q)),
                    ),
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state.status == HomeStatus.loading) {
                        return SliverToBoxAdapter(child: HomeLoadingSkeleton(horizontalPadding: horizontalPadding));
                      }
                      if (state.status == HomeStatus.error || state.data == null) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(l10n.genericError, style: AppTextStyles.bodyMuted),
                                const SizedBox(height: 12),
                                OutlinedButton(
                                  onPressed: () => context.read<HomeCubit>().load(),
                                  child: Text(l10n.retry),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final data = state.data!;
                      final isSearching = _query.trim().isNotEmpty;
                      return SliverPadding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 24),
                        sliver: SliverToBoxAdapter(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 320),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SizeTransition(sizeFactor: anim, axisAlignment: -1, child: child),
                            ),
                            child: isSearching
                                ? KeyedSubtree(key: const ValueKey('search'), child: _buildSearchResults(context, data))
                                : KeyedSubtree(
                                    key: const ValueKey('browse'),
                                    child: _buildBrowseContent(context, data, crossAxisCount),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
