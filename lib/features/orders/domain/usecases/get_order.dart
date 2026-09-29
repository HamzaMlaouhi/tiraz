import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrder implements UseCase<Order, String> {
  final OrdersRepository repository;
  const GetOrder(this.repository);

  @override
  Future<Either<Failure, Order>> call(String id) => repository.getOrder(id);
}
