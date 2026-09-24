import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../models/product_detail_model.dart';

abstract class ProductDataSource {
  Future<ProductDetailModel> getProductDetail(String id);
}

/// `GET /products/:id` — mirrors `ProductsService.findDetail` on the backend.
class ProductRemoteDataSourceImpl implements ProductDataSource {
  final Dio _dio;
  ProductRemoteDataSourceImpl(this._dio);

  @override
  Future<ProductDetailModel> getProductDetail(String id) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/products/$id');
      return ProductDetailModel.fromJson(response.data!);
    });
  }
}
