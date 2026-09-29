import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource remoteDataSource;
  const WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Wallet>> getWallet() async {
    try {
      return Right(await remoteDataSource.getWallet());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
