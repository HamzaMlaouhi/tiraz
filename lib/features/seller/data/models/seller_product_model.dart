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
    super.imageBytes,
  });

  // A couple of starter pieces so the dashboard/products tab isn't empty
  // on first visit — everything after this comes from AddProductPage.
  static List<SellerProductModel> mock() => const [
        SellerProductModel(
          id: 'my-jalabiya-1',
          name: 'Amal jalabiya',
          description: 'Hand-embroidered neckline over soft linen, cut for warm-weather daily wear.',
          priceAed: 540,
          isMadeToMeasure: true,
          isHandmade: true,
          handmadeExtraCostAed: 120,
          lengthCm: 138,
          chestCm: 104,
          sleeveCm: 58,
          quality: JalabiyaQuality.premium,
          imageUrl: 'https://picsum.photos/seed/tiraz-my-product-1/500/650',
        ),
        SellerProductModel(
          id: 'my-jalabiya-2',
          name: 'Rawan kaftan',
          description: 'A relaxed everyday kaftan in breathable cotton blend.',
          priceAed: 380,
          isMadeToMeasure: false,
          isHandmade: false,
          handmadeExtraCostAed: 0,
          lengthCm: 132,
          chestCm: 108,
          sleeveCm: 55,
          quality: JalabiyaQuality.standard,
          imageUrl: 'https://picsum.photos/seed/tiraz-my-product-2/500/650',
        ),
      ];
}
