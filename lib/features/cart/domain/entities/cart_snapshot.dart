import 'package:equatable/equatable.dart';

import 'cart_item.dart';

/// The server's view of the whole cart (`GET /cart`).
class CartSnapshot extends Equatable {
  final List<CartItem> items;
  final bool giftWrap;

  const CartSnapshot({required this.items, required this.giftWrap});

  @override
  List<Object?> get props => [items, giftWrap];
}
