import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  const AuthRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Unit>> sendOtp({required String phone, required String emirate}) async {
    try {
      await localDataSource.sendOtp(phone: phone, emirate: emirate);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOtp(String code) async {
    try {
      await localDataSource.verifyOtp(code);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
