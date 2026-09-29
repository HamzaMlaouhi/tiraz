import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItem implements UseCase<Unit, String> {
  final CartRepository repository;
  const RemoveCartItem(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) => repository.removeItem(id);
}
