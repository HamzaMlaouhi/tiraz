import 'package:dio/dio.dart';

import '../../../../core/network/api_call.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/session/session_store.dart';
import '../models/user_profile_model.dart';

abstract class AccountDataSource {
  Future<UserProfileModel> getProfile();

  /// Updates only the fields given; [emirate] is an `AuthEmirate` value.
  Future<UserProfileModel> updateProfile({String? name, String? emirate});
}

/// `GET /users/me` and `PATCH /users/me` — mirrors tiraz-backend's
/// UsersController.
class AccountRemoteDataSourceImpl implements AccountDataSource {
  final Dio _dio;
  final SessionStore _sessionStore;

  AccountRemoteDataSourceImpl(this._dio, this._sessionStore);

  @override
  Future<UserProfileModel> getProfile() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      return UserProfileModel.fromJson(response.data!);
    });
  }

  @override
  Future<UserProfileModel> updateProfile({String? name, String? emirate}) {
    return guardApiCall(() async {
      final response = await _dio.patch<Map<String, dynamic>>('/users/me', data: {
        if (name != null) 'name': name,
        if (emirate != null) 'emirate': emirate,
      });
      final profile = UserProfileModel.fromJson(response.data!);
      await _syncSession(profile);
      return profile;
    });
  }

  // Keeps the persisted session's name/emirate in step with the server so
  // a cold start shows the edited values before /users/me returns.
  Future<void> _syncSession(UserProfileModel profile) async {
    final session = _sessionStore.current;
    if (session == null) return;
    await _sessionStore.save(AuthSession(
      token: session.token,
      userId: session.userId,
      phone: profile.phone,
      emirate: profile.emirate,
      name: profile.name,
    ));
  }
}
