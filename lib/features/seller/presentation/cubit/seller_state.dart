part of 'seller_cubit.dart';

enum SellerStatus { initial, loading, loaded, error }

class SellerState extends Equatable {
  final SellerStatus status;

  /// Null until the first load completes.
  final SellerStoreProfile? store;
  final List<SellerProduct> products;
  final List<MarketEvent> events;
  final Set<String> reservedEventIds;
  final String? errorMessage;

  const SellerState({
    this.status = SellerStatus.initial,
    this.store,
    this.products = const [],
    this.events = const [],
    this.reservedEventIds = const {},
    this.errorMessage,
  });

  SellerState copyWith({
    SellerStatus? status,
    SellerStoreProfile? store,
    List<SellerProduct>? products,
    List<MarketEvent>? events,
    Set<String>? reservedEventIds,
    String? errorMessage,
  }) {
    return SellerState(
      status: status ?? this.status,
      store: store ?? this.store,
      products: products ?? this.products,
      events: events ?? this.events,
      reservedEventIds: reservedEventIds ?? this.reservedEventIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, store, products, events, reservedEventIds, errorMessage];
}
