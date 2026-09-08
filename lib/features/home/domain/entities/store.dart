import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import 'product_summary.dart';

/// A seller storefront shown on the home feed. [products] is a curated
/// preview (a couple of pieces), not the seller's full catalog — the
/// catalog size for display is [productCount].
class Store extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText emirate;
  final LocalizedText productCount;
  final double rating;
  final int reviewCount;
  final String logoImageUrl;
  final String bannerImageUrl;
  final List<Color> fallbackGradient;
  final List<ProductSummary> products;

  /// A short promo line (e.g. "20% off made-to-measure"), or null when the
  /// store has no active offer. Drives the offer ribbon on [StoreCard] and
  /// the "Offers for you" home rail.
  final LocalizedText? offer;

  const Store({
    required this.id,
    required this.name,
    required this.emirate,
    required this.productCount,
    required this.rating,
    required this.reviewCount,
    required this.logoImageUrl,
    required this.bannerImageUrl,
    required this.fallbackGradient,
    required this.products,
    this.offer,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        emirate,
        productCount,
        rating,
        reviewCount,
        logoImageUrl,
        bannerImageUrl,
        fallbackGradient,
        products,
        offer,
      ];
}
