import 'package:equatable/equatable.dart';

import '../../../../core/value_objects/localized_text.dart';

class FitZone extends Equatable {
  final LocalizedText name;
  final double fitFraction; // 0..1
  final LocalizedText label;

  const FitZone({required this.name, required this.fitFraction, required this.label});

  @override
  List<Object?> get props => [name, fitFraction, label];
}
