import 'package:equatable/equatable.dart';

import '../../../../core/value_objects/localized_text.dart';
import 'cart_item.dart';

/// The server's view of the whole cart (`GET /cart`).
class CartSnapshot extends Equatable {
  final List<CartItem> items;
  final bool giftWrap;

  /// The flat fee before servers reported it — used until the first load.
  static const defaultShippingAed = 20;

  /// Delivery fee the order will be charged (0 for an empty cart).
  final int shippingAed;

  /// Null when the cart is empty (or the server predates the estimate).
  final CartDelivery? delivery;

  const CartSnapshot({required this.items, required this.giftWrap, required this.shippingAed, this.delivery});

  @override
  List<Object?> get props => [items, giftWrap, shippingAed, delivery];
}

/// When the cart would arrive if ordered now — the same estimate the
/// server stores as the order's ETA.
class CartDelivery extends Equatable {
  final LocalizedText etaLabel;
  final bool beforeEid;

  const CartDelivery({required this.etaLabel, required this.beforeEid});

  @override
  List<Object?> get props => [etaLabel, beforeEid];
}
