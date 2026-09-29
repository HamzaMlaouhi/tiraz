import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';

class GetWallet implements UseCase<Wallet, NoParams> {
  final WalletRepository repository;
  const GetWallet(this.repository);

  @override
  Future<Either<Failure, Wallet>> call(NoParams params) => repository.getWallet();
}
