import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/addresses_repository.dart';

class GetAddresses implements UseCase<AddressBook, NoParams> {
  final AddressesRepository repository;
  const GetAddresses(this.repository);

  @override
  Future<Either<Failure, AddressBook>> call(NoParams params) => repository.getAddresses();
}
