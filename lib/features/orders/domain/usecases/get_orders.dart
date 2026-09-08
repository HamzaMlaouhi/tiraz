import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrders implements UseCase<List<Order>, NoParams> {
  final OrdersRepository repository;
  const GetOrders(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) => repository.getOrders();
}
