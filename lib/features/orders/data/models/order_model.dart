import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_timeline_step.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.itemName,
    required super.sellerMeta,
    required super.date,
    required super.etaLabel,
    required super.status,
    required super.imageGradient,
    required super.timeline,
  });

  static const _inProductionTimeline = [
    OrderTimelineStep(
      name: LocalizedText(ar: 'مؤكّد', en: 'Confirmed'),
      sub: LocalizedText(ar: 'اليوم، 2:14 م', en: 'Today, 2:14 pm'),
      stage: TimelineStage.done,
    ),
    OrderTimelineStep(
      name: LocalizedText(ar: 'قيد التنفيذ', en: 'In production'),
      sub: LocalizedText(ar: 'لدى الخيّاطة — يومان متبقّيان', en: 'With the tailor — 2 days left'),
      stage: TimelineStage.now,
    ),
    OrderTimelineStep(
      name: LocalizedText(ar: 'فحص الجودة', en: 'Quality check'),
      sub: LocalizedText(ar: 'موثّق من طِراز', en: 'Tiraz verified'),
      stage: TimelineStage.pending,
    ),
    OrderTimelineStep(
      name: LocalizedText(ar: 'شُحنت', en: 'Shipped'),
      sub: LocalizedText(ar: 'أرامكس', en: 'Aramex'),
      stage: TimelineStage.pending,
    ),
    OrderTimelineStep(
      name: LocalizedText(ar: 'تم التوصيل', en: 'Delivered'),
      sub: LocalizedText(ar: 'مضمون قبل 8 فبراير', en: 'Guaranteed before Feb 8'),
      stage: TimelineStage.pending,
    ),
  ];

  static final _deliveredTimeline = _inProductionTimeline
      .map((s) => OrderTimelineStep(name: s.name, sub: s.sub, stage: TimelineStage.done))
      .toList();

  static List<OrderModel> mock() => [
        const OrderModel(
          id: 'TRZ-2841',
          itemName: LocalizedText(ar: 'جلابية نور — تفصيل', en: 'Noor jalabiya — made-to-measure'),
          sellerMeta: LocalizedText(ar: 'TRZ-2841 · أتيليه نورة', en: 'TRZ-2841 · Atelier Noura'),
          date: LocalizedText(ar: 'طلب في 28 يناير', en: 'Ordered Jan 28'),
          etaLabel: LocalizedText(ar: 'قبل 8 فبراير', en: 'Before Feb 8'),
          status: OrderStatusKind.inProduction,
          imageGradient: [Color(0xFFE6D9C0), Color(0xFFD8C6A6)],
          timeline: _inProductionTimeline,
        ),
        OrderModel(
          id: 'TRZ-2790',
          itemName: const LocalizedText(ar: 'قفطان الفجر — جاهز', en: 'Fajr kaftan — ready-to-wear'),
          sellerMeta: const LocalizedText(ar: 'TRZ-2790 · دار الشيماء', en: 'TRZ-2790 · Dar Al Shaima'),
          date: const LocalizedText(ar: 'طلب في 10 ديسمبر', en: 'Ordered Dec 10'),
          etaLabel: const LocalizedText(ar: 'تم التوصيل', en: 'Delivered'),
          status: OrderStatusKind.delivered,
          imageGradient: const [Color(0xFFDFE9E7), Color(0xFFC6D8D4)],
          timeline: _deliveredTimeline,
        ),
      ];

  /// A freshly placed order — same shape as the seed data, built from
  /// whatever's in the cart at checkout time.
  static OrderModel justPlaced({
    required String id,
    required LocalizedText itemName,
    required LocalizedText sellerMeta,
    required List<Color> imageGradient,
  }) {
    return OrderModel(
      id: id,
      itemName: itemName,
      sellerMeta: sellerMeta,
      date: const LocalizedText(ar: 'طلب اليوم', en: 'Ordered today'),
      etaLabel: const LocalizedText(ar: 'قبل 8 فبراير', en: 'Before Feb 8'),
      status: OrderStatusKind.inProduction,
      imageGradient: imageGradient,
      timeline: _inProductionTimeline,
    );
  }
}
