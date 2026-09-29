import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/entities/wallet_transaction.dart';

class WalletModel extends Wallet {
  const WalletModel({required super.balanceAed, required super.history});

  /// Mirrors `WalletService.getWallet` on the backend.
  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        balanceAed: json['balanceAed'] as int,
        history: (json['history'] as List<dynamic>).map((item) {
          final map = item as Map<String, dynamic>;
          return WalletTransaction(
            name: LocalizedText.fromJson(map['name'] as Map<String, dynamic>),
            date: LocalizedText.fromJson(map['date'] as Map<String, dynamic>),
            amountAed: map['amountAed'] as int,
          );
        }).toList(),
      );
}
