import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource localDataSource;
  const HomeRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      final data = await localDataSource.getHomeData();
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
