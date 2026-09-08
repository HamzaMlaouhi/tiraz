import 'package:equatable/equatable.dart';

import '../../../../core/value_objects/localized_text.dart';

class Address extends Equatable {
  final String id;
  final LocalizedText label;
  final LocalizedText line;

  const Address({required this.id, required this.label, required this.line});

  @override
  List<Object?> get props => [id, label, line];
}
