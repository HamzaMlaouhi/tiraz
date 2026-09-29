import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_profile.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile({String? name, String? emirate});
}
