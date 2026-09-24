import '../../../../core/theme/placeholder_palette.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/occasion.dart';

class OccasionModel extends Occasion {
  const OccasionModel({
    required super.name,
    required super.itemCount,
    required super.background,
    required super.imageUrl,
  });

  /// The backend doesn't carry an occasion id — [imageUrl] is unique per
  /// occasion and always present, so it's the stable key for [background].
  factory OccasionModel.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['imageUrl'] as String;
    return OccasionModel(
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      itemCount: LocalizedText.fromJson(json['itemCount'] as Map<String, dynamic>),
      background: PlaceholderPalette.occasionBackgroundFor(imageUrl),
      imageUrl: imageUrl,
    );
  }
}
