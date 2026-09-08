import '../../../../core/error/exceptions.dart';
import '../models/product_detail_model.dart';

abstract class ProductLocalDataSource {
  Future<ProductDetailModel> getProductDetail(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<ProductDetailModel> getProductDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final product = ProductDetailModel.byId(id);
    if (product == null) {
      throw ServerException('Product "$id" not found');
    }
    return product;
  }
}
