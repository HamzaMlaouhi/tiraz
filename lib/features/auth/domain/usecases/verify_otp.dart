import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp implements UseCase<Unit, String> {
  final AuthRepository repository;
  const VerifyOtp(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String code) {
    return repository.verifyOtp(code);
  }
}
