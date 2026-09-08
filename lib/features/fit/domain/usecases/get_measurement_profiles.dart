import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/measurement_profile.dart';
import '../repositories/fit_repository.dart';

class GetMeasurementProfiles implements UseCase<List<MeasurementProfile>, NoParams> {
  final FitRepository repository;
  const GetMeasurementProfiles(this.repository);

  @override
  Future<Either<Failure, List<MeasurementProfile>>> call(NoParams params) => repository.getProfiles();
}
