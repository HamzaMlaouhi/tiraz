import 'package:equatable/equatable.dart';

import '../../../../core/value_objects/localized_text.dart';

enum EidDeadlineStatus { open, closingSoon, closed }

/// When to order a piece so it arrives before Eid, for one mode (RTW or
/// MTM) — computed by the server from the Eid date, the seller's lead
/// days and delivery time.
class EidDeadline extends Equatable {
  final DateTime orderBy;

  /// Negative once the deadline has passed.
  final int daysLeft;
  final EidDeadlineStatus status;
  final LocalizedText label;

  const EidDeadline({required this.orderBy, required this.daysLeft, required this.status, required this.label});

  @override
  List<Object?> get props => [orderBy, daysLeft, status, label];
}
