import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/measurement_profile.dart';

class MeasurementProfileModel extends MeasurementProfile {
  const MeasurementProfileModel({
    required super.id,
    required super.name,
    required super.completedCount,
    required super.totalCount,
    required super.statusLabel,
  });

  /// Mirrors `FitService.toDto` on the backend.
  factory MeasurementProfileModel.fromJson(Map<String, dynamic> json) => MeasurementProfileModel(
        id: json['id'] as String,
        name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
        completedCount: json['completedCount'] as int,
        totalCount: json['totalCount'] as int,
        statusLabel: LocalizedText.fromJson(json['statusLabel'] as Map<String, dynamic>),
      );
}
