import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDataSource remoteDataSource;
  const AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      return Right(await remoteDataSource.getProfile());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile({String? name, String? emirate}) async {
    try {
      return Right(await remoteDataSource.updateProfile(name: name, emirate: emirate));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
