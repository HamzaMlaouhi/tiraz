import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/seller_repository.dart';

class GetMarketEvent implements UseCase<EventStatus, String> {
  final SellerRepository repository;
  const GetMarketEvent(this.repository);

  @override
  Future<Either<Failure, EventStatus>> call(String id) => repository.getEvent(id);
}
