import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/new_seller_product.dart';
import '../models/market_event_model.dart';
import '../models/seller_product_model.dart';
import '../models/seller_store_profile_model.dart';

abstract class SellerDataSource {
  /// The current user's store, creating it on first use ("become a seller").
  Future<SellerStoreProfileModel> ensureStore();

  Future<List<SellerProductModel>> getProducts();
  Future<SellerProductModel> getProduct(String id);
  Future<SellerProductModel> createProduct(NewSellerProduct product);
  Future<void> deleteProduct(String id);

  Future<List<MarketEventModel>> getEvents();
  Future<MarketEventModel> getEvent(String id);
  Future<void> reserveEvent(String id);
  Future<void> cancelReservation(String id);
}

/// `/sellers/me`, `/sellers/products`, `/uploads/product-image` and
/// `/events` — mirrors tiraz-backend's seller-side controllers.
class SellerRemoteDataSourceImpl implements SellerDataSource {
  final Dio _dio;
  SellerRemoteDataSourceImpl(this._dio);

  @override
  Future<SellerStoreProfileModel> ensureStore() {
    return guardApiCall(() async {
      try {
        final response = await _dio.get<Map<String, dynamic>>('/sellers/me');
        return SellerStoreProfileModel.fromJson(response.data!);
      } on DioException catch (e) {
        // SellerGuard answers 403 until the account has a store.
        if (e.response?.statusCode != 403) rethrow;
      }
      final response = await _dio.post<Map<String, dynamic>>('/sellers/me', data: <String, dynamic>{});
      return SellerStoreProfileModel.fromJson(response.data!);
    });
  }

  @override
  Future<List<SellerProductModel>> getProducts() {
    return guardApiCall(() async {
      final response = await _dio.get<List<dynamic>>('/sellers/products');
      return response.data!.map((item) => SellerProductModel.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<SellerProductModel> getProduct(String id) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/sellers/products/$id');
      return SellerProductModel.fromJson(response.data!);
    });
  }

  @override
  Future<SellerProductModel> createProduct(NewSellerProduct product) {
    return guardApiCall(() async {
      final bytes = product.imageBytes;
      final imageUrl = bytes != null ? await _uploadImage(bytes) : product.imageUrl;
      final response = await _dio.post<Map<String, dynamic>>('/sellers/products', data: {
        'name': product.name.trim(),
        'description': product.description.trim(),
        'priceAed': product.priceAed,
        'isMadeToMeasure': product.isMadeToMeasure,
        'isHandmade': product.isHandmade,
        'handmadeExtraCostAed': product.isHandmade ? product.handmadeExtraCostAed : 0,
        'lengthCm': product.lengthCm,
        'chestCm': product.chestCm,
        'sleeveCm': product.sleeveCm,
        'quality': product.quality.name.toUpperCase(),
        'imageUrl': imageUrl,
      });
      return SellerProductModel.fromJson(response.data!);
    });
  }

  /// `POST /uploads/product-image` (multipart field `file`).
  Future<String> _uploadImage(Uint8List bytes) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: 'product.jpg', contentType: DioMediaType('image', 'jpeg')),
    });
    final response = await _dio.post<Map<String, dynamic>>('/uploads/product-image', data: form);
    return _reachableUploadUrl(response.data!['imageUrl'] as String);
  }

  /// The backend always answers `http://localhost:<port>/uploads/…`, which
  /// (a) doesn't resolve from an emulator/device and (b) fails its own
  /// `@IsUrl()` check on create (no TLD). Point it at the host this app
  /// actually talks to, using an IP for loopback so validation passes.
  static String _reachableUploadUrl(String url) {
    final api = Uri.parse(ApiConfig.baseUrl);
    final host = api.host == 'localhost' ? '127.0.0.1' : api.host;
    return Uri.parse(url).replace(scheme: api.scheme, host: host, port: api.port).toString();
  }

  @override
  Future<void> deleteProduct(String id) => guardApiCall(() => _dio.delete<void>('/sellers/products/$id'));

  @override
  Future<List<MarketEventModel>> getEvents() {
    return guardApiCall(() async {
      final response = await _dio.get<List<dynamic>>('/events');
      return response.data!.map((item) => MarketEventModel.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<MarketEventModel> getEvent(String id) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/events/$id');
      return MarketEventModel.fromJson(response.data!);
    });
  }

  @override
  Future<void> reserveEvent(String id) => guardApiCall(() => _dio.post<void>('/events/$id/reservations'));

  @override
  Future<void> cancelReservation(String id) => guardApiCall(() => _dio.delete<void>('/events/$id/reservations'));
}
