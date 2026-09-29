import '../../../../core/theme/placeholder_palette.dart';
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

  /// Mirrors `SellersService.toDto` on the backend.
  factory SellerStoreProfileModel.fromJson(Map<String, dynamic> json) => SellerStoreProfileModel(
        name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
        emirate: LocalizedText.fromJson(json['emirate'] as Map<String, dynamic>),
        logoImageUrl: json['logoImageUrl'] as String,
        bannerImageUrl: json['bannerImageUrl'] as String,
        fallbackGradient: PlaceholderPalette.gradientFor(json['id'] as String),
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
      );
}
