import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../entities/measurement_profile.dart';
import '../repositories/fit_repository.dart';

class CreateMeasurementProfile implements UseCase<MeasurementProfile, LocalizedText> {
  final FitRepository repository;
  const CreateMeasurementProfile(this.repository);

  @override
  Future<Either<Failure, MeasurementProfile>> call(LocalizedText name) => repository.createProfile(name);
}
