import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/seller_repository.dart';

/// Reserves a booth ([EventReservationParams.reserve] true) or cancels it.
class SetEventReservation implements UseCase<Unit, EventReservationParams> {
  final SellerRepository repository;
  const SetEventReservation(this.repository);

  @override
  Future<Either<Failure, Unit>> call(EventReservationParams params) => params.reserve
      ? repository.reserveEvent(params.eventId)
      : repository.cancelReservation(params.eventId);
}

class EventReservationParams extends Equatable {
  final String eventId;
  final bool reserve;

  const EventReservationParams({required this.eventId, required this.reserve});

  @override
  List<Object?> get props => [eventId, reserve];
}
