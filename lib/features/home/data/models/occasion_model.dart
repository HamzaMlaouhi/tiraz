import '../../../../core/theme/app_colors.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/occasion.dart';

class OccasionModel extends Occasion {
  const OccasionModel({
    required super.name,
    required super.itemCount,
    required super.background,
    required super.imageUrl,
  });

  static List<OccasionModel> mock() => const [
        OccasionModel(
          name: LocalizedText(ar: 'صباح العيد', en: 'Eid morning'),
          itemCount: LocalizedText(ar: '214 قطعة', en: '214 pieces'),
          background: AppColors.occasionSand,
          imageUrl: 'https://picsum.photos/seed/tiraz-occasion-eid/400/280',
        ),
        OccasionModel(
          name: LocalizedText(ar: 'إفطار رمضان', en: 'Ramadan iftar'),
          itemCount: LocalizedText(ar: '368 قطعة', en: '368 pieces'),
          background: AppColors.occasionMint,
          imageUrl: 'https://picsum.photos/seed/tiraz-occasion-iftar/400/280',
        ),
        OccasionModel(
          name: LocalizedText(ar: 'خطوبة وأعراس', en: 'Engagements'),
          itemCount: LocalizedText(ar: '156 قطعة', en: '156 pieces'),
          background: AppColors.occasionTaupe,
          imageUrl: 'https://picsum.photos/seed/tiraz-occasion-engagement/400/280',
        ),
        OccasionModel(
          name: LocalizedText(ar: 'المجلس', en: 'Majlis'),
          itemCount: LocalizedText(ar: '290 قطعة', en: '290 pieces'),
          background: AppColors.occasionCream,
          imageUrl: 'https://picsum.photos/seed/tiraz-occasion-majlis/400/280',
        ),
      ];
}
