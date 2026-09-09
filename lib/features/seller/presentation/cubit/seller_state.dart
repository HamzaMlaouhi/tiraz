part of 'seller_cubit.dart';

class SellerState extends Equatable {
  final SellerStoreProfile store;
  final List<SellerProduct> products;
  final List<MarketEvent> events;
  final Set<String> reservedEventIds;

  const SellerState({
    required this.store,
    required this.products,
    required this.events,
    required this.reservedEventIds,
  });

  SellerState copyWith({
    SellerStoreProfile? store,
    List<SellerProduct>? products,
    List<MarketEvent>? events,
    Set<String>? reservedEventIds,
  }) {
    return SellerState(
      store: store ?? this.store,
      products: products ?? this.products,
      events: events ?? this.events,
      reservedEventIds: reservedEventIds ?? this.reservedEventIds,
    );
  }

  @override
  List<Object?> get props => [store, products, events, reservedEventIds];
}
