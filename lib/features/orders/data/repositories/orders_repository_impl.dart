import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersDataSource remoteDataSource;
  const OrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Order>>> getOrders() => _run(remoteDataSource.getOrders);

  @override
  Future<Either<Failure, Order>> getOrder(String id) => _run(() => remoteDataSource.getOrder(id));

  @override
  Future<Either<Failure, Order>> placeOrder({required String addressId, required String paymentMethod}) =>
      _run(() => remoteDataSource.placeOrder(addressId: addressId, paymentMethod: paymentMethod));

  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
