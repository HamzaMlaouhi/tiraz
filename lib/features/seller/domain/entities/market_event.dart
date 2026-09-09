import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';

/// A pop-up market a seller can reserve a booth at — curated dummy data,
/// so (like Occasion/Store) its copy is bilingual editorial content.
class MarketEvent extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText emirate;
  final LocalizedText venue;
  final LocalizedText dateLabel;
  final LocalizedText timeLabel;
  final int totalSlots;
  final int reservedSlots;
  final int attendeeCount;
  final bool isFree;
  final double feeAed;
  final String imageUrl;
  final List<Color> fallbackGradient;

  const MarketEvent({
    required this.id,
    required this.name,
    required this.emirate,
    required this.venue,
    required this.dateLabel,
    required this.timeLabel,
    required this.totalSlots,
    required this.reservedSlots,
    required this.attendeeCount,
    required this.isFree,
    required this.feeAed,
    required this.imageUrl,
    required this.fallbackGradient,
  });

  int get slotsLeft => totalSlots - reservedSlots;

  @override
  List<Object?> get props => [
        id,
        name,
        emirate,
        venue,
        dateLabel,
        timeLabel,
        totalSlots,
        reservedSlots,
        attendeeCount,
        isFree,
        feeAed,
        imageUrl,
        fallbackGradient,
      ];
}
