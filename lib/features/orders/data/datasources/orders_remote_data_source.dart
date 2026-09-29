import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../models/order_model.dart';

abstract class OrdersDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrder(String id);

  /// Turns the server-side cart into an order (and empties the cart).
  /// [paymentMethod] is one of `applePay`, `bankCard`, `tabby`, `cod`.
  Future<OrderModel> placeOrder({required String addressId, required String paymentMethod});

  /// Rates a delivered order (once); returns the order with its review.
  Future<OrderModel> submitReview(String orderId, {required int rating, String? comment});
}

/// `GET /orders`, `GET /orders/:id`, `POST /orders`, `POST /orders/:id/review`
/// — mirrors tiraz-backend's
/// OrdersController.
class OrdersRemoteDataSourceImpl implements OrdersDataSource {
  final Dio _dio;
  OrdersRemoteDataSourceImpl(this._dio);

  @override
  Future<List<OrderModel>> getOrders() {
    return guardApiCall(() async {
      final response = await _dio.get<List<dynamic>>('/orders');
      return response.data!.map((item) => OrderModel.fromJson(item as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<OrderModel> getOrder(String id) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/orders/$id');
      return OrderModel.fromJson(response.data!);
    });
  }

  @override
  Future<OrderModel> placeOrder({required String addressId, required String paymentMethod}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/orders', data: {
        'addressId': addressId,
        'paymentMethod': paymentMethod,
      });
      return OrderModel.fromJson(response.data!);
    });
  }

  @override
  Future<OrderModel> submitReview(String orderId, {required int rating, String? comment}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/orders/$orderId/review', data: {
        'rating': rating,
        if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
      });
      return OrderModel.fromJson(response.data!);
    });
  }
}
