import '../../../../core/theme/placeholder_palette.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/product_summary.dart';

class ProductSummaryModel extends ProductSummary {
  const ProductSummaryModel({
    required super.id,
    required super.name,
    required super.seller,
    required super.price,
    required super.isMadeToMeasure,
    required super.imageGradient,
    required super.imageUrl,
  });

  /// Mirrors `ProductsService.toSummaryDto` on the backend.
  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return ProductSummaryModel(
      id: id,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      seller: LocalizedText.fromJson(json['seller'] as Map<String, dynamic>),
      price: LocalizedText.fromJson(json['price'] as Map<String, dynamic>),
      isMadeToMeasure: json['isMadeToMeasure'] as bool,
      imageGradient: PlaceholderPalette.gradientFor(id),
      imageUrl: json['imageUrl'] as String,
    );
  }

  static List<ProductSummaryModel> listFromJson(List<dynamic> json) =>
      json.map((item) => ProductSummaryModel.fromJson(item as Map<String, dynamic>)).toList();
}
