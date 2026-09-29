import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../entities/measurement_profile.dart';

abstract class FitRepository {
  Future<Either<Failure, List<MeasurementProfile>>> getProfiles();
  Future<Either<Failure, MeasurementProfile>> createProfile(LocalizedText name);
  Future<Either<Failure, MeasurementProfile>> submitMeasurement(
    String profileId, {
    required String key,
    required double valueCm,
  });
}
