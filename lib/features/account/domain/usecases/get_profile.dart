import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/account_repository.dart';

class GetProfile implements UseCase<UserProfile, NoParams> {
  final AccountRepository repository;
  const GetProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) => repository.getProfile();
}
