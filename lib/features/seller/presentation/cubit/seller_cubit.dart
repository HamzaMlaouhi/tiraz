import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/market_event_model.dart';
import '../../data/models/seller_product_model.dart';
import '../../data/models/seller_store_profile_model.dart';
import '../../domain/entities/market_event.dart';
import '../../domain/entities/seller_product.dart';
import '../../domain/entities/seller_store_profile.dart';

part 'seller_state.dart';

/// Everything about the current session's seller side — their store
/// profile, their product listings, and their event reservations. Purely
/// local state, no repository: like Cart/Wishlist/Wallet there's nothing
/// to fetch, only to seed once and mutate for the session.
class SellerCubit extends Cubit<SellerState> {
  SellerCubit()
      : super(SellerState(
          store: SellerStoreProfileModel.mock(),
          products: SellerProductModel.mock(),
          events: MarketEventModel.mock(),
          reservedEventIds: const {},
        ));

  void addProduct({required String name, required double priceAed, required bool isMadeToMeasure}) {
    final seed = Uri.encodeComponent('${name.trim()}-${state.products.length}');
    final product = SellerProduct(
      id: 'seller-product-${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      priceAed: priceAed,
      isMadeToMeasure: isMadeToMeasure,
      imageUrl: 'https://picsum.photos/seed/tiraz-seller-$seed/500/650',
    );
    emit(state.copyWith(products: [...state.products, product]));
  }

  void removeProduct(String id) {
    emit(state.copyWith(products: state.products.where((p) => p.id != id).toList()));
  }

  void reserveEvent(String eventId) {
    if (state.reservedEventIds.contains(eventId)) return;
    emit(state.copyWith(reservedEventIds: {...state.reservedEventIds, eventId}));
  }

  void cancelReservation(String eventId) {
    final updated = {...state.reservedEventIds}..remove(eventId);
    emit(state.copyWith(reservedEventIds: updated));
  }
}
