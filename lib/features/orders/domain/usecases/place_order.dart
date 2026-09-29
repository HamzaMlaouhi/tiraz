import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class PlaceOrder implements UseCase<Order, PlaceOrderParams> {
  final OrdersRepository repository;
  const PlaceOrder(this.repository);

  @override
  Future<Either<Failure, Order>> call(PlaceOrderParams params) =>
      repository.placeOrder(addressId: params.addressId, paymentMethod: params.paymentMethod);
}

class PlaceOrderParams extends Equatable {
  final String addressId;

  /// One of `CheckoutCubit.paymentKeys`.
  final String paymentMethod;

  const PlaceOrderParams({required this.addressId, required this.paymentMethod});

  @override
  List<Object?> get props => [addressId, paymentMethod];
}
