import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/usecases/get_wallet.dart';

part 'wallet_state.dart';

/// Registered as a lazy singleton so the Account row's balance stays in
/// sync with whatever this page shows.
class WalletCubit extends Cubit<WalletState> {
  Timer? _copiedResetTimer;

  final GetWallet _getWallet;

  WalletCubit({required GetWallet getWallet})
      : _getWallet = getWallet,
        super(const WalletState());

  Future<void> load() async {
    if (state.status != WalletStatus.loaded) emit(state.copyWith(status: WalletStatus.loading));
    final result = await _getWallet(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: WalletStatus.error, errorMessage: failure.message)),
      (wallet) => emit(state.copyWith(
        status: WalletStatus.loaded,
        balanceAed: wallet.balanceAed,
        history: wallet.history,
      )),
    );
  }

  Future<void> copyInviteLink() async {
    await Clipboard.setData(const ClipboardData(text: 'https://tiraz.app/invite/hamza'));
    emit(state.copyWith(copied: true));
    _copiedResetTimer?.cancel();
    _copiedResetTimer = Timer(const Duration(seconds: 3), () => emit(state.copyWith(copied: false)));
  }

  @override
  Future<void> close() {
    _copiedResetTimer?.cancel();
    return super.close();
  }
}
