import 'package:equatable/equatable.dart';

import 'wallet_transaction.dart';

/// `GET /wallet`: the server-computed balance plus newest-first history.
class Wallet extends Equatable {
  final int balanceAed;
  final List<WalletTransaction> history;

  const Wallet({required this.balanceAed, required this.history});

  @override
  List<Object?> get props => [balanceAed, history];
}
