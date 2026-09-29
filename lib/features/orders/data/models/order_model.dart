import '../../../../core/theme/placeholder_palette.dart';
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

  /// Mirrors `OrdersService.toDto` on the backend. Orders carry no image,
  /// so the tile keeps a placeholder gradient keyed by order id.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return OrderModel(
      id: id,
      itemName: _text(json['itemName']),
      sellerMeta: _text(json['sellerMeta']),
      date: _text(json['date']),
      etaLabel: _text(json['etaLabel']),
      status: json['status'] == 'delivered' ? OrderStatusKind.delivered : OrderStatusKind.inProduction,
      imageGradient: PlaceholderPalette.gradientFor(id),
      timeline: (json['timeline'] as List<dynamic>).map((step) {
        final map = step as Map<String, dynamic>;
        return OrderTimelineStep(
          name: _text(map['name']),
          sub: _text(map['sub']),
          stage: TimelineStage.values.byName(map['stage'] as String),
        );
      }).toList(),
    );
  }

  static LocalizedText _text(dynamic json) => LocalizedText.fromJson(json as Map<String, dynamic>);
}
