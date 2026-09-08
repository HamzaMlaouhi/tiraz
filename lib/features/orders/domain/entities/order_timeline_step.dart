import 'package:equatable/equatable.dart';

import '../../../../core/value_objects/localized_text.dart';

enum TimelineStage { done, now, pending }

class OrderTimelineStep extends Equatable {
  final LocalizedText name;
  final LocalizedText sub;
  final TimelineStage stage;

  const OrderTimelineStep({required this.name, required this.sub, required this.stage});

  @override
  List<Object?> get props => [name, sub, stage];
}
