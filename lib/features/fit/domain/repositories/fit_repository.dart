import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/measurement_profile.dart';

abstract class FitRepository {
  Future<Either<Failure, List<MeasurementProfile>>> getProfiles();
}
