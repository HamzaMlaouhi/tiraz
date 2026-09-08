import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/store.dart';
import 'product_summary_model.dart';

class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.name,
    required super.emirate,
    required super.productCount,
    required super.rating,
    required super.reviewCount,
    required super.logoImageUrl,
    required super.bannerImageUrl,
    required super.fallbackGradient,
    required super.products,
    super.offer,
  });

  /// Deterministic, seed-based placeholder photography (picsum.photos) —
  /// stands in for real store photography. Every card and sheet falls back
  /// to [fallbackGradient] if the network image can't load, so the app
  /// still looks intentional offline.
  static String _photo(String seed, int width, int height) => 'https://picsum.photos/seed/tiraz-$seed/$width/$height';

  static List<StoreModel> mock() => [
        StoreModel(
          id: 'atelier-noura',
          name: const LocalizedText(ar: 'أتيليه نورة', en: 'Atelier Noura'),
          emirate: const LocalizedText(ar: 'دبي', en: 'Dubai'),
          productCount: const LocalizedText(ar: '128 قطعة', en: '128 pieces'),
          rating: 4.9,
          reviewCount: 132,
          logoImageUrl: _photo('atelier-noura-logo', 160, 160),
          bannerImageUrl: _photo('atelier-noura-banner', 700, 420),
          fallbackGradient: const [Color(0xFFE6D9C0), Color(0xFFD8C6A6)],
          products: const [ProductSummaryModel.noorJalabiya, ProductSummaryModel.widadJalabiya],
          offer: const LocalizedText(ar: 'خصم 20% على التفصيل', en: '20% off made-to-measure'),
        ),
        StoreModel(
          id: 'dar-al-shaima',
          name: const LocalizedText(ar: 'دار الشيماء', en: 'Dar Al Shaima'),
          emirate: const LocalizedText(ar: 'أبوظبي', en: 'Abu Dhabi'),
          productCount: const LocalizedText(ar: '76 قطعة', en: '76 pieces'),
          rating: 4.6,
          reviewCount: 74,
          logoImageUrl: _photo('dar-al-shaima-logo', 160, 160),
          bannerImageUrl: _photo('dar-al-shaima-banner', 700, 420),
          fallbackGradient: const [Color(0xFFDFE9E7), Color(0xFFC6D8D4)],
          products: const [ProductSummaryModel.fajrKaftan, ProductSummaryModel.layaliAbaya],
        ),
        StoreModel(
          id: 'silk-house',
          name: const LocalizedText(ar: 'بيت الحرير', en: 'Silk House'),
          emirate: const LocalizedText(ar: 'الشارقة', en: 'Sharjah'),
          productCount: const LocalizedText(ar: '164 قطعة', en: '164 pieces'),
          rating: 4.8,
          reviewCount: 168,
          logoImageUrl: _photo('silk-house-logo', 160, 160),
          bannerImageUrl: _photo('silk-house-banner', 700, 420),
          fallbackGradient: const [Color(0xFFE8DDD2), Color(0xFFD4C3B4)],
          products: const [ProductSummaryModel.yasmeenJalabiya, ProductSummaryModel.lulwaKaftan],
          offer: const LocalizedText(ar: 'تعديل مجاني مع كل طلب', en: 'Free alterations on every order'),
        ),
        StoreModel(
          id: 'bait-al-abaya',
          name: const LocalizedText(ar: 'بيت العباية', en: 'Bait Al Abaya'),
          emirate: const LocalizedText(ar: 'عجمان', en: 'Ajman'),
          productCount: const LocalizedText(ar: '52 قطعة', en: '52 pieces'),
          rating: 4.5,
          reviewCount: 51,
          logoImageUrl: _photo('bait-al-abaya-logo', 160, 160),
          bannerImageUrl: _photo('bait-al-abaya-banner', 700, 420),
          fallbackGradient: const [Color(0xFFE3E8DE), Color(0xFFC7D2BC)],
          products: const [ProductSummaryModel.mahaJalabiya, ProductSummaryModel.reemJalabiya],
        ),
        StoreModel(
          id: 'rimal-atelier',
          name: const LocalizedText(ar: 'أتيليه الرمال', en: 'Rimal Atelier'),
          emirate: const LocalizedText(ar: 'رأس الخيمة', en: 'Ras Al Khaimah'),
          productCount: const LocalizedText(ar: '89 قطعة', en: '89 pieces'),
          rating: 4.7,
          reviewCount: 89,
          logoImageUrl: _photo('rimal-atelier-logo', 160, 160),
          bannerImageUrl: _photo('rimal-atelier-banner', 700, 420),
          fallbackGradient: const [Color(0xFFE8DCEA), Color(0xFFD1BBD9)],
          products: const [ProductSummaryModel.aljawharaSet, ProductSummaryModel.noofAbaya],
          offer: const LocalizedText(ar: 'اشتري قطعتين ووفّري 10%', en: 'Buy 2 pieces, save 10%'),
        ),
      ];
}
