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

  static List<MeasurementProfileModel> mock() => const [
        MeasurementProfileModel(
          id: 'me',
          name: LocalizedText(ar: 'أنا', en: 'Me'),
          completedCount: 14,
          totalCount: 14,
          statusLabel: LocalizedText(ar: 'مكتمل — آخر تحديث في مارس', en: 'Complete — last updated in March'),
        ),
        MeasurementProfileModel(
          id: 'sara',
          name: LocalizedText(ar: 'سارة (ابنتي)', en: 'Sara (daughter)'),
          completedCount: 10,
          totalCount: 14,
          statusLabel: LocalizedText(ar: '4 قياسات متبقّية', en: '4 measurements remaining'),
        ),
        MeasurementProfileModel(
          id: 'mother',
          name: LocalizedText(ar: 'والدتي', en: 'My mother'),
          completedCount: 0,
          totalCount: 14,
          statusLabel: LocalizedText(ar: 'لم يبدأ بعد', en: 'Not started yet'),
        ),
      ];
}
