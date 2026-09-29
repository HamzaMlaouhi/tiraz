import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/measurement_profile.dart';
import '../repositories/fit_repository.dart';

class SubmitMeasurement implements UseCase<MeasurementProfile, SubmitMeasurementParams> {
  final FitRepository repository;
  const SubmitMeasurement(this.repository);

  @override
  Future<Either<Failure, MeasurementProfile>> call(SubmitMeasurementParams params) =>
      repository.submitMeasurement(params.profileId, key: params.key, valueCm: params.valueCm);
}

class SubmitMeasurementParams extends Equatable {
  final String profileId;
  final String key;
  final double valueCm;

  const SubmitMeasurementParams({required this.profileId, required this.key, required this.valueCm});

  @override
  List<Object?> get props => [profileId, key, valueCm];
}
