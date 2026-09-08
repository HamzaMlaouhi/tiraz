import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

class WishlistItem extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText seller;
  final int priceAed;
  final List<Color> imageGradient;

  const WishlistItem({
    required this.id,
    required this.name,
    required this.seller,
    required this.priceAed,
    required this.imageGradient,
  });

  @override
  List<Object?> get props => [id, name, seller, priceAed, imageGradient];
}
