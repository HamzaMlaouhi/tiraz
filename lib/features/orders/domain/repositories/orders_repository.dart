import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../entities/order.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, Order>> getOrder(String id);
  Future<Either<Failure, Order>> placeOrder({required String addressId, required String paymentMethod});
  Future<Either<Failure, Order>> submitReview(String orderId, {required int rating, String? comment});
}
