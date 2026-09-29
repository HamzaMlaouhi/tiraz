import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/addresses_repository.dart';

class DeleteAddress implements UseCase<Unit, String> {
  final AddressesRepository repository;
  const DeleteAddress(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) => repository.remove(id);
}
