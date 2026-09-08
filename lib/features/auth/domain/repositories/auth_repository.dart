import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class AuthRepository {
  /// Sends a one-time code to [phone] (assumed UAE, +971) for [emirate].
  Future<Either<Failure, Unit>> sendOtp({required String phone, required String emirate});

  /// Verifies the previously sent code.
  Future<Either<Failure, Unit>> verifyOtp(String code);
}
