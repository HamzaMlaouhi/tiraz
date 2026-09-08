part of 'cart_cubit.dart';

class CartState extends Equatable {
  static const shippingAed = 20;

  final List<CartItem> items;
  final bool giftWrap;

  const CartState({this.items = const [], this.giftWrap = true});

  int get itemCount => items.length;
  int get subtotalAed => items.fold(0, (sum, item) => sum + item.priceAed);
  int get totalAed => items.isEmpty ? 0 : subtotalAed + shippingAed;

  CartState copyWith({List<CartItem>? items, bool? giftWrap}) {
    return CartState(items: items ?? this.items, giftWrap: giftWrap ?? this.giftWrap);
  }

  @override
  List<Object?> get props => [items, giftWrap];
}
