import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

/// A saved piece. [id] is the wishlist entry's own id (what DELETE takes);
/// [productId] is the catalog product it points at.
class WishlistItem extends Equatable {
  final String id;
  final String productId;
  final LocalizedText name;
  final LocalizedText seller;
  final int priceAed;
  final String imageUrl;
  final List<Color> imageGradient;

  const WishlistItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.seller,
    required this.priceAed,
    required this.imageUrl,
    required this.imageGradient,
  });

  @override
  List<Object?> get props => [id, productId, name, seller, priceAed, imageUrl, imageGradient];
}
