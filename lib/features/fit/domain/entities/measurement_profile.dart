import 'package:equatable/equatable.dart';

import '../../../../core/value_objects/localized_text.dart';

class MeasurementProfile extends Equatable {
  final String id;
  final LocalizedText name;
  final int completedCount;
  final int totalCount;
  final LocalizedText statusLabel;

  const MeasurementProfile({
    required this.id,
    required this.name,
    required this.completedCount,
    required this.totalCount,
    required this.statusLabel,
  });

  bool get isComplete => completedCount >= totalCount;

  @override
  List<Object?> get props => [id, name, completedCount, totalCount, statusLabel];
}
