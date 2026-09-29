part of 'cart_cubit.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItem> items;
  final bool giftWrap;

  /// Delivery fee per order, from the server.
  final int shippingAed;

  /// From the last server fetch; refreshed by [CartCubit.load].
  final CartDelivery? delivery;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.giftWrap = false,
    this.shippingAed = CartSnapshot.defaultShippingAed,
    this.delivery,
    this.errorMessage,
  });

  int get itemCount => items.length;
  int get subtotalAed => items.fold(0, (sum, item) => sum + item.priceAed);
  int get totalAed => items.isEmpty ? 0 : subtotalAed + shippingAed;

  CartState copyWith({CartStatus? status, List<CartItem>? items, bool? giftWrap, String? errorMessage}) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      giftWrap: giftWrap ?? this.giftWrap,
      shippingAed: shippingAed,
      delivery: delivery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, giftWrap, shippingAed, delivery, errorMessage];
}
