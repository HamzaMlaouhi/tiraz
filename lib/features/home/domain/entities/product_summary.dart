import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

/// A product as shown in a listing (home drops carousel). The full
/// [ProductDetail] entity lives in the product feature and is fetched
/// separately once the shopper taps through.
class ProductSummary extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText seller;
  final LocalizedText price;
  final bool isMadeToMeasure;
  final List<Color> imageGradient;
  final String imageUrl;

  const ProductSummary({
    required this.id,
    required this.name,
    required this.seller,
    required this.price,
    required this.isMadeToMeasure,
    required this.imageGradient,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, seller, price, isMadeToMeasure, imageGradient, imageUrl];
}
