import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

/// One line in the cart — built at "add to cart" time from a
/// [ProductDetail] plus whichever mode/size/profile was selected, or
/// from a family-set member. Cart itself doesn't know about products.
class CartItem extends Equatable {
  final String id;
  final LocalizedText seller;
  final LocalizedText leadLabel;
  final LocalizedText itemName;
  final LocalizedText variant;
  final int priceAed;
  final List<Color> imageGradient;

  const CartItem({
    required this.id,
    required this.seller,
    required this.leadLabel,
    required this.itemName,
    required this.variant,
    required this.priceAed,
    required this.imageGradient,
  });

  @override
  List<Object?> get props => [id, seller, leadLabel, itemName, variant, priceAed, imageGradient];
}
