import '../../../../core/theme/placeholder_palette.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.seller,
    required super.leadLabel,
    required super.itemName,
    required super.variant,
    required super.priceAed,
    required super.imageGradient,
  });

  /// Mirrors `CartService.toDto` on the backend. The API has no image for a
  /// cart line, so the tile keeps the placeholder gradient, keyed by id.
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return CartItemModel(
      id: id,
      seller: LocalizedText.fromJson(json['seller'] as Map<String, dynamic>),
      leadLabel: LocalizedText.fromJson(json['leadLabel'] as Map<String, dynamic>),
      itemName: LocalizedText.fromJson(json['itemName'] as Map<String, dynamic>),
      variant: LocalizedText.fromJson(json['variant'] as Map<String, dynamic>),
      priceAed: json['priceAed'] as int,
      imageGradient: PlaceholderPalette.gradientFor(id),
    );
  }
}
