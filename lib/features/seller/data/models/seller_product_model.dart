import '../../domain/entities/seller_product.dart';

class SellerProductModel extends SellerProduct {
  const SellerProductModel({
    required super.id,
    required super.name,
    required super.priceAed,
    required super.isMadeToMeasure,
    required super.imageUrl,
  });

  // A couple of starter pieces so the dashboard/products tab isn't empty
  // on first visit — everything after this comes from AddProductPage.
  static List<SellerProductModel> mock() => const [
        SellerProductModel(
          id: 'my-jalabiya-1',
          name: 'Amal jalabiya',
          priceAed: 540,
          isMadeToMeasure: true,
          imageUrl: 'https://picsum.photos/seed/tiraz-my-product-1/500/650',
        ),
        SellerProductModel(
          id: 'my-jalabiya-2',
          name: 'Rawan kaftan',
          priceAed: 380,
          isMadeToMeasure: false,
          imageUrl: 'https://picsum.photos/seed/tiraz-my-product-2/500/650',
        ),
      ];
}
