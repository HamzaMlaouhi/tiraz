part of 'cart_cubit.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  static const shippingAed = 20;

  final CartStatus status;
  final List<CartItem> items;
  final bool giftWrap;
  final String? errorMessage;

  const CartState({this.status = CartStatus.initial, this.items = const [], this.giftWrap = false, this.errorMessage});

  int get itemCount => items.length;
  int get subtotalAed => items.fold(0, (sum, item) => sum + item.priceAed);
  int get totalAed => items.isEmpty ? 0 : subtotalAed + shippingAed;

  CartState copyWith({CartStatus? status, List<CartItem>? items, bool? giftWrap, String? errorMessage}) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      giftWrap: giftWrap ?? this.giftWrap,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, giftWrap, errorMessage];
}
