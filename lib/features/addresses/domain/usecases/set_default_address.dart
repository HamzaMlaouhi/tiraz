import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/addresses_repository.dart';

class SetDefaultAddress implements UseCase<Unit, String> {
  final AddressesRepository repository;
  const SetDefaultAddress(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) => repository.setDefault(id);
}
