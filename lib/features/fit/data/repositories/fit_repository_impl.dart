import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/measurement_profile.dart';
import '../../domain/repositories/fit_repository.dart';
import '../datasources/fit_local_data_source.dart';

class FitRepositoryImpl implements FitRepository {
  final FitLocalDataSource localDataSource;
  const FitRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<MeasurementProfile>>> getProfiles() async {
    try {
      final profiles = await localDataSource.getProfiles();
      return Right(profiles);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
