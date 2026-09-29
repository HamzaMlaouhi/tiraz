import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../entities/address.dart';

/// Address list plus which one is the default (null only when the list is
/// empty).
typedef AddressBook = ({List<Address> addresses, String? defaultId});

abstract class AddressesRepository {
  Future<Either<Failure, AddressBook>> getAddresses();
  Future<Either<Failure, Unit>> create({required LocalizedText label, required LocalizedText line});
  Future<Either<Failure, Unit>> update(String id, {LocalizedText? label, LocalizedText? line});
  Future<Either<Failure, Unit>> remove(String id);
  Future<Either<Failure, Unit>> setDefault(String id);
}
