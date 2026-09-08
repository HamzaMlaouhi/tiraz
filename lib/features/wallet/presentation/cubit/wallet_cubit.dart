import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/wallet_transaction.dart';

part 'wallet_state.dart';

/// Registered as a lazy singleton so the Account row's balance stays in
/// sync with whatever this page shows.
class WalletCubit extends Cubit<WalletState> {
  Timer? _copiedResetTimer;

  WalletCubit()
      : super(
          const WalletState(
            history: [
              WalletTransaction(
                name: LocalizedText(ar: 'مكافأة الترحيب', en: 'Welcome bonus'),
                date: LocalizedText(ar: '20 ديسمبر', en: 'Dec 20'),
                amountAed: 20,
              ),
              WalletTransaction(
                name: LocalizedText(ar: 'مكافأة إحالة — سارة', en: 'Referral bonus — Sara'),
                date: LocalizedText(ar: '2 يناير', en: 'Jan 2'),
                amountAed: 50,
              ),
              WalletTransaction(
                name: LocalizedText(ar: 'استُخدم في طلب TRZ-2841', en: 'Used on order TRZ-2841'),
                date: LocalizedText(ar: '15 يناير', en: 'Jan 15'),
                amountAed: -20,
              ),
            ],
          ),
        );

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
