import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../entities/order.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<Order>>> getOrders();
}
