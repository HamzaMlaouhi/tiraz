import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/session/auth_session.dart';
import '../../../../core/session/session_store.dart';

abstract class AuthDataSource {
  /// Requests a fresh 4-digit code for [phone] (9 digits, no country code,
  /// matching the backend's `RequestOtpDto`) under [emirate] (one of this
  /// app's `kEmirateKeys`, e.g. `emirateDubai`). Returns the challengeId
  /// [verifyOtp] must be called with.
  Future<String> sendOtp({required String phone, required String emirate});

  /// Verifies [code] against the challenge from the most recent [sendOtp]
  /// call and, on success, persists the resulting session.
  Future<void> verifyOtp(String code);
}

/// Real HTTP implementation, talking to `POST /auth/otp/request` and
/// `POST /auth/otp/verify` — see tiraz-backend's AuthService for the exact
/// contract this mirrors.
class AuthRemoteDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  final SessionStore _sessionStore;

  // The OTP flow is two calls against one short-lived challenge; the
  // AuthCubit above this (a singleton, shared by AuthPage and OtpPage)
  // never runs two challenges concurrently, so a single mutable field is
  // enough — no need to thread challengeId back through the domain layer.
  String? _challengeId;

  AuthRemoteDataSourceImpl(this._dio, this._sessionStore);

  @override
  Future<String> sendOtp({required String phone, required String emirate}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>('/auth/otp/request', data: {
        'phone': phone,
        'emirate': _emirateToApi(emirate),
      });
      final challengeId = response.data!['challengeId'] as String;
      _challengeId = challengeId;
      return challengeId;
    });
  }

  @override
  Future<void> verifyOtp(String code) {
    return guardApiCall(() async {
      final challengeId = _challengeId;
      if (challengeId == null) {
        throw const ServerException('Request a new code first');
      }
      final response = await _dio.post<Map<String, dynamic>>('/auth/otp/verify', data: {
        'challengeId': challengeId,
        'code': code,
      });
      final data = response.data!;
      final user = data['user'] as Map<String, dynamic>;
      await _sessionStore.save(AuthSession(
        token: data['accessToken'] as String,
        userId: user['id'] as String,
        phone: user['phone'] as String,
        emirate: user['emirate'] as String,
        name: user['name'] as String?,
      ));
      _challengeId = null;
    });
  }

  static String _emirateToApi(String key) {
    switch (key) {
      case 'emirateDubai':
        return 'DUBAI';
      case 'emirateAbuDhabi':
        return 'ABU_DHABI';
      case 'emirateSharjah':
        return 'SHARJAH';
      default:
        return 'OTHER';
    }
  }
}
