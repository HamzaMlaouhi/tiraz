import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtp implements UseCase<Unit, SendOtpParams> {
  final AuthRepository repository;
  const SendOtp(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SendOtpParams params) {
    return repository.sendOtp(phone: params.phone, emirate: params.emirate);
  }
}

class SendOtpParams extends Equatable {
  final String phone;
  final String emirate;
  const SendOtpParams({required this.phone, required this.emirate});

  @override
  List<Object?> get props => [phone, emirate];
}
