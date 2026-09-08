import 'package:equatable/equatable.dart';

import '../../../../core/value_objects/localized_text.dart';

class WalletTransaction extends Equatable {
  final LocalizedText name;
  final LocalizedText date;
  final int amountAed;

  const WalletTransaction({required this.name, required this.date, required this.amountAed});

  @override
  List<Object?> get props => [name, date, amountAed];
}
