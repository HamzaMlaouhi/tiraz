import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/account_repository.dart';

class UpdateProfile implements UseCase<UserProfile, UpdateProfileParams> {
  final AccountRepository repository;
  const UpdateProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UpdateProfileParams params) =>
      repository.updateProfile(name: params.name, emirate: params.emirate);
}

class UpdateProfileParams extends Equatable {
  final String? name;
  final String? emirate;

  const UpdateProfileParams({this.name, this.emirate});

  @override
  List<Object?> get props => [name, emirate];
}
