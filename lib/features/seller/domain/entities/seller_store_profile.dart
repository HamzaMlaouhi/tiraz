import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

/// The current seller's own storefront — their "origin store" shown on
/// the seller dashboard. Deliberately separate from the buyer-side [Store]
/// entity (which carries a curated product preview list of its own) so
/// the seller feature doesn't reach across into the home feature's types.
class SellerStoreProfile extends Equatable {
  final LocalizedText name;
  final LocalizedText emirate;
  final String logoImageUrl;
  final String bannerImageUrl;
  final List<Color> fallbackGradient;
  final double rating;
  final int reviewCount;

  const SellerStoreProfile({
    required this.name,
    required this.emirate,
    required this.logoImageUrl,
    required this.bannerImageUrl,
    required this.fallbackGradient,
    required this.rating,
    required this.reviewCount,
  });

  @override
  List<Object?> get props => [name, emirate, logoImageUrl, bannerImageUrl, fallbackGradient, rating, reviewCount];
}
