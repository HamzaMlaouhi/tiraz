part of 'auth_cubit.dart';

enum AuthStatus { idle, submittingPhone, otpSent, verifying, verified, error }

class AuthState extends Equatable {
  final String phone;
  final int emirateIndex;
  final String otp;
  final AuthStatus status;
  final String? errorMessage;
  final int resendSecondsLeft;

  const AuthState({
    this.phone = '',
    this.emirateIndex = 0,
    this.otp = '',
    this.status = AuthStatus.idle,
    this.errorMessage,
    this.resendSecondsLeft = 24,
  });

  AuthState copyWith({
    String? phone,
    int? emirateIndex,
    String? otp,
    AuthStatus? status,
    String? errorMessage,
    bool clearError = false,
    int? resendSecondsLeft,
  }) {
    return AuthState(
      phone: phone ?? this.phone,
      emirateIndex: emirateIndex ?? this.emirateIndex,
      otp: otp ?? this.otp,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      resendSecondsLeft: resendSecondsLeft ?? this.resendSecondsLeft,
    );
  }

  @override
  List<Object?> get props => [phone, emirateIndex, otp, status, errorMessage, resendSecondsLeft];
}
