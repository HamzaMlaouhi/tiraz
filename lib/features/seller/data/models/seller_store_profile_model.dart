import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/seller_store_profile.dart';

class SellerStoreProfileModel extends SellerStoreProfile {
  const SellerStoreProfileModel({
    required super.name,
    required super.emirate,
    required super.logoImageUrl,
    required super.bannerImageUrl,
    required super.fallbackGradient,
    required super.rating,
    required super.reviewCount,
  });

  // Ties to the same "Hamza · Abu Dhabi" persona the account page shows —
  // this is that shopper's own storefront once they switch to selling.
  static SellerStoreProfileModel mock() => const SellerStoreProfileModel(
        name: LocalizedText(ar: 'أتيليه حمزة', en: "Hamza's Atelier"),
        emirate: LocalizedText(ar: 'أبوظبي', en: 'Abu Dhabi'),
        logoImageUrl: 'https://picsum.photos/seed/tiraz-my-store-logo/160/160',
        bannerImageUrl: 'https://picsum.photos/seed/tiraz-my-store-banner/700/420',
        fallbackGradient: [Color(0xFFE3DCE8), Color(0xFFC9BFD6)],
        rating: 4.7,
        reviewCount: 12,
      );
}
