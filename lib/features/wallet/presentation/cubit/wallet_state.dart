part of 'wallet_cubit.dart';

class WalletState extends Equatable {
  final List<WalletTransaction> history;
  final bool copied;

  const WalletState({required this.history, this.copied = false});

  int get balanceAed => history.fold(0, (sum, t) => sum + t.amountAed);

  WalletState copyWith({List<WalletTransaction>? history, bool? copied}) {
    return WalletState(history: history ?? this.history, copied: copied ?? this.copied);
  }

  @override
  List<Object?> get props => [history, copied];
}
