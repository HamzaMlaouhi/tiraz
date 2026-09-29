import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/repositories/addresses_repository.dart';
import '../datasources/addresses_remote_data_source.dart';

class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesDataSource remoteDataSource;
  const AddressesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AddressBook>> getAddresses() async {
    try {
      final addresses = await remoteDataSource.getAddresses();
      final defaults = addresses.where((a) => a.isDefault);
      return Right((
        addresses: addresses,
        defaultId: defaults.isNotEmpty ? defaults.first.id : (addresses.isNotEmpty ? addresses.first.id : null),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> create({required LocalizedText label, required LocalizedText line}) =>
      _run(() => remoteDataSource.create(label: label, line: line));

  @override
  Future<Either<Failure, Unit>> update(String id, {LocalizedText? label, LocalizedText? line}) =>
      _run(() => remoteDataSource.update(id, label: label, line: line));

  @override
  Future<Either<Failure, Unit>> remove(String id) => _run(() => remoteDataSource.remove(id));

  @override
  Future<Either<Failure, Unit>> setDefault(String id) => _run(() => remoteDataSource.setDefault(id));

  Future<Either<Failure, Unit>> _run(Future<void> Function() call) async {
    try {
      await call();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
