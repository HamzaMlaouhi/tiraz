import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/wallet.dart';

abstract class WalletRepository {
  Future<Either<Failure, Wallet>> getWallet();
}
