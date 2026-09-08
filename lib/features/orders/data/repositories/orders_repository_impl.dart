import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_local_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersLocalDataSource localDataSource;
  const OrdersRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final orders = await localDataSource.getOrders();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
