import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class SubmitOrderReview implements UseCase<Order, OrderReviewParams> {
  final OrdersRepository repository;
  const SubmitOrderReview(this.repository);

  @override
  Future<Either<Failure, Order>> call(OrderReviewParams params) =>
      repository.submitReview(params.orderId, rating: params.rating, comment: params.comment);
}

class OrderReviewParams extends Equatable {
  final String orderId;
  final int rating;
  final String? comment;

  const OrderReviewParams({required this.orderId, required this.rating, this.comment});

  @override
  List<Object?> get props => [orderId, rating, comment];
}
