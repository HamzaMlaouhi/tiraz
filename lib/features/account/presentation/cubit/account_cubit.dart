import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  AccountCubit({required GetProfile getProfile, required UpdateProfile updateProfile})
      : _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(const AccountState());

  Future<void> load() async {
    // Keep showing the last profile while refreshing, so re-entering the
    // tab doesn't flash the header back to a placeholder.
    if (state.profile == null) emit(state.copyWith(status: AccountStatus.loading));
    final result = await _getProfile(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: AccountStatus.error, errorMessage: failure.message)),
      (profile) => emit(state.copyWith(status: AccountStatus.loaded, profile: profile)),
    );
  }

  /// Returns the failure message, or null on success, so the caller can
  /// surface it inline (e.g. in the edit-name sheet).
  Future<String?> updateName(String name) async {
    final result = await _updateProfile(UpdateProfileParams(name: name));
    return result.fold(
      (failure) => failure.message,
      (profile) {
        emit(state.copyWith(status: AccountStatus.loaded, profile: profile));
        return null;
      },
    );
  }
}
