import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/measurement_profile.dart';
import '../../domain/repositories/fit_repository.dart';
import '../datasources/fit_remote_data_source.dart';

class FitRepositoryImpl implements FitRepository {
  final FitDataSource remoteDataSource;
  const FitRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MeasurementProfile>>> getProfiles() => _run(remoteDataSource.getProfiles);

  @override
  Future<Either<Failure, MeasurementProfile>> createProfile(LocalizedText name) =>
      _run(() => remoteDataSource.createProfile(name));

  @override
  Future<Either<Failure, MeasurementProfile>> submitMeasurement(
    String profileId, {
    required String key,
    required double valueCm,
  }) =>
      _run(() => remoteDataSource.submitMeasurement(profileId, key: key, valueCm: valueCm));

  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
