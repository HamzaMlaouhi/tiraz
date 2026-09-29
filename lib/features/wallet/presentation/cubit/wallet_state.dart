part of 'wallet_cubit.dart';

enum WalletStatus { initial, loading, loaded, error }

class WalletState extends Equatable {
  final WalletStatus status;
  final int balanceAed;
  final List<WalletTransaction> history;
  final bool copied;
  final String? errorMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.balanceAed = 0,
    this.history = const [],
    this.copied = false,
    this.errorMessage,
  });

  WalletState copyWith({
    WalletStatus? status,
    int? balanceAed,
    List<WalletTransaction>? history,
    bool? copied,
    String? errorMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      balanceAed: balanceAed ?? this.balanceAed,
      history: history ?? this.history,
      copied: copied ?? this.copied,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, balanceAed, history, copied, errorMessage];
}
