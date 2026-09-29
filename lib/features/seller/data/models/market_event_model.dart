import '../../../../core/theme/placeholder_palette.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/market_event.dart';

class MarketEventModel extends MarketEvent {
  /// Whether the signed-in seller holds a booth here (`reservedByMe`).
  final bool isReservedByMe;

  const MarketEventModel({
    required super.id,
    required super.name,
    required super.emirate,
    required super.venue,
    required super.dateLabel,
    required super.timeLabel,
    required super.totalSlots,
    required super.reservedSlots,
    required super.attendeeCount,
    required super.isFree,
    required super.feeAed,
    required super.imageUrl,
    required super.fallbackGradient,
    required this.isReservedByMe,
  });

  /// Mirrors `EventsService.toEventDto` on the backend.
  factory MarketEventModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    LocalizedText text(String key) => LocalizedText.fromJson(json[key] as Map<String, dynamic>);
    return MarketEventModel(
      id: id,
      name: text('name'),
      emirate: text('emirate'),
      venue: text('venue'),
      dateLabel: text('dateLabel'),
      timeLabel: text('timeLabel'),
      totalSlots: json['totalSlots'] as int,
      reservedSlots: json['reservedSlots'] as int,
      attendeeCount: json['attendeeCount'] as int,
      isFree: json['isFree'] as bool,
      feeAed: (json['feeAed'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      fallbackGradient: PlaceholderPalette.gradientFor(id),
      isReservedByMe: json['reservedByMe'] as bool,
    );
  }
}
