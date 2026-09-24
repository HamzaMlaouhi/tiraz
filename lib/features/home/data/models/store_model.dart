import '../../../../core/theme/placeholder_palette.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/store.dart';
import 'product_summary_model.dart';

class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.name,
    required super.emirate,
    required super.productCount,
    required super.rating,
    required super.reviewCount,
    required super.logoImageUrl,
    required super.bannerImageUrl,
    required super.fallbackGradient,
    required super.products,
    super.offer,
  });

  /// Mirrors `StoresService.toStoreDto` on the backend.
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final offer = json['offer'] as Map<String, dynamic>?;
    return StoreModel(
      id: id,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      emirate: LocalizedText.fromJson(json['emirate'] as Map<String, dynamic>),
      productCount: LocalizedText.fromJson(json['productCount'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      logoImageUrl: json['logoImageUrl'] as String,
      bannerImageUrl: json['bannerImageUrl'] as String,
      fallbackGradient: PlaceholderPalette.gradientFor(id),
      products: ProductSummaryModel.listFromJson(json['products'] as List<dynamic>),
      offer: offer != null ? LocalizedText.fromJson(offer) : null,
    );
  }

  static List<StoreModel> listFromJson(List<dynamic> json) =>
      json.map((item) => StoreModel.fromJson(item as Map<String, dynamic>)).toList();
}
