import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/market_event.dart';

class MarketEventModel extends MarketEvent {
  const MarketEventModel({
    required super.id,
    required super.name,
    required super.emirate,
    required super.venue,
    required super.dateLabel,
    required super.totalSlots,
    required super.reservedSlots,
    required super.imageUrl,
    required super.fallbackGradient,
  });

  static List<MarketEventModel> mock() => const [
        MarketEventModel(
          id: 'ramadan-souq-dubai',
          name: LocalizedText(ar: 'سوق رمضان', en: 'Ramadan Souq'),
          emirate: LocalizedText(ar: 'دبي', en: 'Dubai'),
          venue: LocalizedText(ar: 'مدينة جميرا الرياضية', en: 'Dubai Sports City'),
          dateLabel: LocalizedText(ar: '12–14 مارس', en: 'Mar 12–14'),
          totalSlots: 40,
          reservedSlots: 31,
          imageUrl: 'https://picsum.photos/seed/tiraz-event-ramadan-souq/700/420',
          fallbackGradient: [Color(0xFFF3EAD9), Color(0xFFECE0C8)],
        ),
        MarketEventModel(
          id: 'eid-bazaar-sharjah',
          name: LocalizedText(ar: 'بازار العيد', en: 'Eid Bazaar'),
          emirate: LocalizedText(ar: 'الشارقة', en: 'Sharjah'),
          venue: LocalizedText(ar: 'مركز إكسبو الشارقة', en: 'Expo Centre Sharjah'),
          dateLabel: LocalizedText(ar: '20–22 مارس', en: 'Mar 20–22'),
          totalSlots: 25,
          reservedSlots: 25,
          imageUrl: 'https://picsum.photos/seed/tiraz-event-eid-bazaar/700/420',
          fallbackGradient: [Color(0xFFDFE9E7), Color(0xFFC6D8D4)],
        ),
        MarketEventModel(
          id: 'design-market-abu-dhabi',
          name: LocalizedText(ar: 'سوق المصمّمات', en: 'Designer Market'),
          emirate: LocalizedText(ar: 'أبوظبي', en: 'Abu Dhabi'),
          venue: LocalizedText(ar: 'جزيرة السعديات', en: 'Saadiyat Island'),
          dateLabel: LocalizedText(ar: '2–3 أبريل', en: 'Apr 2–3'),
          totalSlots: 18,
          reservedSlots: 9,
          imageUrl: 'https://picsum.photos/seed/tiraz-event-design-market/700/420',
          fallbackGradient: [Color(0xFFE8DCEA), Color(0xFFD1BBD9)],
        ),
        MarketEventModel(
          id: 'family-day-ajman',
          name: LocalizedText(ar: 'يوم العائلة', en: 'Family Day Market'),
          emirate: LocalizedText(ar: 'عجمان', en: 'Ajman'),
          venue: LocalizedText(ar: 'كورنيش عجمان', en: 'Ajman Corniche'),
          dateLabel: LocalizedText(ar: '15 أبريل', en: 'Apr 15'),
          totalSlots: 30,
          reservedSlots: 6,
          imageUrl: 'https://picsum.photos/seed/tiraz-event-family-day/700/420',
          fallbackGradient: [Color(0xFFE3E8DE), Color(0xFFC7D2BC)],
        ),
      ];
}
