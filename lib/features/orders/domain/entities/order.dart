import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/value_objects/localized_text.dart';
import 'order_timeline_step.dart';

enum OrderStatusKind { inProduction, delivered }

class Order extends Equatable {
  final String id;
  final LocalizedText itemName;
  final LocalizedText sellerMeta;
  final LocalizedText date;
  final LocalizedText etaLabel;
  final OrderStatusKind status;
  final List<Color> imageGradient;
  final List<OrderTimelineStep> timeline;

  const Order({
    required this.id,
    required this.itemName,
    required this.sellerMeta,
    required this.date,
    required this.etaLabel,
    required this.status,
    required this.imageGradient,
    required this.timeline,
  });

  @override
  List<Object?> get props => [id, itemName, sellerMeta, date, etaLabel, status, imageGradient, timeline];
}
