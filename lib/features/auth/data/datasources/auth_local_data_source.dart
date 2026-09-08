import '../../../../core/error/exceptions.dart';

/// Mock data source standing in for a real backend. Any 4-digit code
/// verifies except "0000", which simulates a wrong-code response — swap
/// this class for an HTTP-backed one when a real API is available; the
/// repository/domain/presentation layers above it don't change.
abstract class AuthLocalDataSource {
  Future<void> sendOtp({required String phone, required String emirate});
  Future<void> verifyOtp(String code);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> sendOtp({required String phone, required String emirate}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (phone.trim().isEmpty) {
      throw const ServerException('Phone number is required');
    }
  }

  @override
  Future<void> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (code.length != 4) {
      throw const ServerException('Enter the 4-digit code');
    }
    if (code == '0000') {
      throw const ServerException('Incorrect code');
    }
  }
}
