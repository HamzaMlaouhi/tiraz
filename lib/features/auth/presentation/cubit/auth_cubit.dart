import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';

part 'auth_state.dart';

const List<String> kEmirateKeys = ['emirateDubai', 'emirateAbuDhabi', 'emirateSharjah', 'emirateOther'];

class AuthCubit extends Cubit<AuthState> {
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;
  Timer? _resendTimer;

  AuthCubit({required SendOtp sendOtp, required VerifyOtp verifyOtp})
      : _sendOtp = sendOtp,
        _verifyOtp = verifyOtp,
        super(const AuthState());

  void phoneChanged(String value) => emit(state.copyWith(phone: value, clearError: true));

  void emirateSelected(int index) => emit(state.copyWith(emirateIndex: index));

  void otpChanged(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    emit(state.copyWith(otp: digits.length > 4 ? digits.substring(0, 4) : digits, clearError: true));
  }

  Future<void> sendCode() async {
    emit(state.copyWith(status: AuthStatus.submittingPhone, clearError: true));
    final result = await _sendOtp(SendOtpParams(phone: state.phone, emirate: kEmirateKeys[state.emirateIndex]));
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.error, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(status: AuthStatus.otpSent, otp: ''));
        _startResendCountdown();
      },
    );
  }

  Future<bool> verify() async {
    emit(state.copyWith(status: AuthStatus.verifying, clearError: true));
    final result = await _verifyOtp(state.otp);
    var success = false;
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.error, errorMessage: failure.message)),
      (_) {
        success = true;
        emit(state.copyWith(status: AuthStatus.verified));
      },
    );
    return success;
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    emit(state.copyWith(resendSecondsLeft: 24));
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendSecondsLeft <= 1) {
        timer.cancel();
        emit(state.copyWith(resendSecondsLeft: 0));
        return;
      }
      emit(state.copyWith(resendSecondsLeft: state.resendSecondsLeft - 1));
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
