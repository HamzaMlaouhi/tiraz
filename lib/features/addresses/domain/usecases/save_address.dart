import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../repositories/addresses_repository.dart';

/// Creates a new address when [SaveAddressParams.id] is null, otherwise
/// updates that one.
class SaveAddress implements UseCase<Unit, SaveAddressParams> {
  final AddressesRepository repository;
  const SaveAddress(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveAddressParams params) {
    final id = params.id;
    if (id == null) return repository.create(label: params.label, line: params.line);
    return repository.update(id, label: params.label, line: params.line);
  }
}

class SaveAddressParams extends Equatable {
  final String? id;
  final LocalizedText label;
  final LocalizedText line;

  const SaveAddressParams({this.id, required this.label, required this.line});

  @override
  List<Object?> get props => [id, label, line];
}
