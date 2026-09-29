import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../models/wishlist_item_model.dart';

abstract class WishlistDataSource {
  Future<List<WishlistItemModel>> getWishlist();

  /// Idempotent on the server: saving an already-saved product returns the
  /// existing entry.
  Future<WishlistItemModel> add(String productId);

  /// [id] is the wishlist entry id, not the product id.
  Future<void> remove(String id);
}

/// `GET/POST /wishlist` and `DELETE /wishlist/:id` — mirrors tiraz-backend's
/// WishlistController.
class WishlistRemoteDataSourceImpl implements WishlistDataSource {
  final Dio _dio;
  WishlistRemoteDataSourceImpl(this._dio);

  @override
  Future<List<WishlistItemModel>> getWishlist() {
    return guardApiCall(() async {
      final response = await _dio.get<List<dynamic>>('/wishlist');
      return response.data!.map((item) => WishlistItemModel.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<WishlistItemModel> add(String productId) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/wishlist', data: {'productId': productId});
      return WishlistItemModel.fromJson(response.data!);
    });
  }

  @override
  Future<void> remove(String id) => guardApiCall(() => _dio.delete<void>('/wishlist/$id'));
}
