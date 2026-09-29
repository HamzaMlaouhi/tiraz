import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart_snapshot.dart';
import '../repositories/cart_repository.dart';

class GetCart implements UseCase<CartSnapshot, NoParams> {
  final CartRepository repository;
  const GetCart(this.repository);

  @override
  Future<Either<Failure, CartSnapshot>> call(NoParams params) => repository.getCart();
}
