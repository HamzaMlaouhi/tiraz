import '../../domain/entities/jalabiya_quality.dart';
import '../../domain/entities/seller_product.dart';

class SellerProductModel extends SellerProduct {
  const SellerProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.priceAed,
    required super.isMadeToMeasure,
    required super.isHandmade,
    required super.handmadeExtraCostAed,
    required super.lengthCm,
    required super.chestCm,
    required super.sleeveCm,
    required super.quality,
    required super.imageUrl,
  });

  /// Mirrors `ProductsService.toSellerDto` on the backend. [quality] comes
  /// over the wire as the Prisma enum (`STANDARD`/`PREMIUM`/`LUXURY`).
  factory SellerProductModel.fromJson(Map<String, dynamic> json) => SellerProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        priceAed: (json['priceAed'] as num).toDouble(),
        isMadeToMeasure: json['isMadeToMeasure'] as bool,
        isHandmade: json['isHandmade'] as bool,
        handmadeExtraCostAed: (json['handmadeExtraCostAed'] as num).toDouble(),
        lengthCm: (json['lengthCm'] as num).toDouble(),
        chestCm: (json['chestCm'] as num).toDouble(),
        sleeveCm: (json['sleeveCm'] as num).toDouble(),
        quality: JalabiyaQuality.values.byName((json['quality'] as String).toLowerCase()),
        imageUrl: json['imageUrl'] as String,
      );
}
