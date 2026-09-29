import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cart_repository.dart';

class SetGiftWrap implements UseCase<Unit, bool> {
  final CartRepository repository;
  const SetGiftWrap(this.repository);

  @override
  Future<Either<Failure, Unit>> call(bool giftWrap) => repository.setGiftWrap(giftWrap);
}
