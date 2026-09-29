import '../../../../core/theme/placeholder_palette.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.seller,
    required super.priceAed,
    required super.imageUrl,
    required super.imageGradient,
  });

  /// Mirrors `WishlistService.toDto` on the backend.
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final productId = json['productId'] as String;
    return WishlistItemModel(
      id: json['id'] as String,
      productId: productId,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      seller: LocalizedText.fromJson(json['seller'] as Map<String, dynamic>),
      priceAed: json['priceAed'] as int,
      imageUrl: json['imageUrl'] as String,
      imageGradient: PlaceholderPalette.gradientFor(productId),
    );
  }
}
