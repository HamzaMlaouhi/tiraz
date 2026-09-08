import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/product_summary.dart';

class ProductSummaryModel extends ProductSummary {
  const ProductSummaryModel({
    required super.id,
    required super.name,
    required super.seller,
    required super.price,
    required super.isMadeToMeasure,
    required super.imageGradient,
    required super.imageUrl,
  });

  // Named so store previews (see StoreModel) can reference the exact same
  // piece shown in "New from your designers" instead of duplicating it.
  // imageUrl is deterministic placeholder photography (picsum.photos, seeded
  // by product id) — imageGradient stays as the offline fallback.
  static const noorJalabiya = ProductSummaryModel(
    id: 'noor-jalabiya',
    name: LocalizedText(ar: 'جلابية نور', en: 'Noor jalabiya'),
    seller: LocalizedText(ar: 'أتيليه نورة — دبي', en: 'Atelier Noura — Dubai'),
    price: LocalizedText(ar: '780 د.إ', en: 'AED 780'),
    isMadeToMeasure: true,
    imageGradient: [Color(0xFFE6D9C0), Color(0xFFD8C6A6)],
    imageUrl: 'https://picsum.photos/seed/tiraz-noor-jalabiya/500/650',
  );

  static const fajrKaftan = ProductSummaryModel(
    id: 'fajr-kaftan',
    name: LocalizedText(ar: 'قفطان الفجر', en: 'Fajr kaftan'),
    seller: LocalizedText(ar: 'دار الشيماء', en: 'Dar Al Shaima'),
    price: LocalizedText(ar: '420 د.إ', en: 'AED 420'),
    isMadeToMeasure: false,
    imageGradient: [Color(0xFFDFE9E7), Color(0xFFC6D8D4)],
    imageUrl: 'https://picsum.photos/seed/tiraz-fajr-kaftan/500/650',
  );

  static const yasmeenJalabiya = ProductSummaryModel(
    id: 'yasmeen-jalabiya',
    name: LocalizedText(ar: 'جلابية ياسمين', en: 'Yasmeen jalabiya'),
    seller: LocalizedText(ar: 'بيت الحرير', en: 'Silk House'),
    price: LocalizedText(ar: '1,150 د.إ', en: 'AED 1,150'),
    isMadeToMeasure: true,
    imageGradient: [Color(0xFFE8DDD2), Color(0xFFD4C3B4)],
    imageUrl: 'https://picsum.photos/seed/tiraz-yasmeen-jalabiya/500/650',
  );

  static const widadJalabiya = ProductSummaryModel(
    id: 'widad-jalabiya',
    name: LocalizedText(ar: 'جلابية وداد', en: 'Widad jalabiya'),
    seller: LocalizedText(ar: 'أتيليه نورة — دبي', en: 'Atelier Noura — Dubai'),
    price: LocalizedText(ar: '650 د.إ', en: 'AED 650'),
    isMadeToMeasure: true,
    imageGradient: [Color(0xFFEFE3D3), Color(0xFFDCC9AA)],
    imageUrl: 'https://picsum.photos/seed/tiraz-widad-jalabiya/500/650',
  );

  static const layaliAbaya = ProductSummaryModel(
    id: 'layali-abaya',
    name: LocalizedText(ar: 'عباية ليالي', en: 'Layali abaya'),
    seller: LocalizedText(ar: 'دار الشيماء — أبوظبي', en: 'Dar Al Shaima — Abu Dhabi'),
    price: LocalizedText(ar: '560 د.إ', en: 'AED 560'),
    isMadeToMeasure: false,
    imageGradient: [Color(0xFFE3DCE8), Color(0xFFC9BFD6)],
    imageUrl: 'https://picsum.photos/seed/tiraz-layali-abaya/500/650',
  );

  static const lulwaKaftan = ProductSummaryModel(
    id: 'lulwa-kaftan',
    name: LocalizedText(ar: 'قفطان لولوة', en: 'Lulwa kaftan'),
    seller: LocalizedText(ar: 'بيت الحرير — الشارقة', en: 'Silk House — Sharjah'),
    price: LocalizedText(ar: '980 د.إ', en: 'AED 980'),
    isMadeToMeasure: true,
    imageGradient: [Color(0xFFF1E6D6), Color(0xFFE0CBA0)],
    imageUrl: 'https://picsum.photos/seed/tiraz-lulwa-kaftan/500/650',
  );

  static const mahaJalabiya = ProductSummaryModel(
    id: 'maha-jalabiya',
    name: LocalizedText(ar: 'جلابية مها', en: 'Maha jalabiya'),
    seller: LocalizedText(ar: 'بيت العباية — عجمان', en: 'Bait Al Abaya — Ajman'),
    price: LocalizedText(ar: '260 د.إ', en: 'AED 260'),
    isMadeToMeasure: false,
    imageGradient: [Color(0xFFE3E8DE), Color(0xFFC7D2BC)],
    imageUrl: 'https://picsum.photos/seed/tiraz-maha-jalabiya/500/650',
  );

  static const reemJalabiya = ProductSummaryModel(
    id: 'reem-jalabiya',
    name: LocalizedText(ar: 'جلابية ريم', en: 'Reem jalabiya'),
    seller: LocalizedText(ar: 'بيت العباية — عجمان', en: 'Bait Al Abaya — Ajman'),
    price: LocalizedText(ar: '290 د.إ', en: 'AED 290'),
    isMadeToMeasure: false,
    imageGradient: [Color(0xFFEAD9D2), Color(0xFFD6B9AC)],
    imageUrl: 'https://picsum.photos/seed/tiraz-reem-jalabiya/500/650',
  );

  static const aljawharaSet = ProductSummaryModel(
    id: 'aljawhara-set',
    name: LocalizedText(ar: 'طقم الجوهرة', en: 'Aljawhara set'),
    seller: LocalizedText(ar: 'أتيليه الرمال — رأس الخيمة', en: 'Rimal Atelier — Ras Al Khaimah'),
    price: LocalizedText(ar: '890 د.إ', en: 'AED 890'),
    isMadeToMeasure: true,
    imageGradient: [Color(0xFFE8DCEA), Color(0xFFD1BBD9)],
    imageUrl: 'https://picsum.photos/seed/tiraz-aljawhara-set/500/650',
  );

  static const noofAbaya = ProductSummaryModel(
    id: 'noof-abaya',
    name: LocalizedText(ar: 'عباية نوف', en: 'Noof abaya'),
    seller: LocalizedText(ar: 'أتيليه الرمال — رأس الخيمة', en: 'Rimal Atelier — Ras Al Khaimah'),
    price: LocalizedText(ar: '480 د.إ', en: 'AED 480'),
    isMadeToMeasure: false,
    imageGradient: [Color(0xFFDDE6E6), Color(0xFFBFD0D0)],
    imageUrl: 'https://picsum.photos/seed/tiraz-noof-abaya/500/650',
  );

  static List<ProductSummaryModel> mock() => const [noorJalabiya, fajrKaftan, yasmeenJalabiya];

  /// Every mocked piece across the catalog (new drops + every store's
  /// preview), deduplicated by id — the source list for home search.
  static List<ProductSummaryModel> all() => const [
        noorJalabiya,
        fajrKaftan,
        yasmeenJalabiya,
        widadJalabiya,
        layaliAbaya,
        lulwaKaftan,
        mahaJalabiya,
        reemJalabiya,
        aljawharaSet,
        noofAbaya,
      ];
}
