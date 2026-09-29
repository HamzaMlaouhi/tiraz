import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/seller_repository.dart';

class GetSellerOverview implements UseCase<SellerOverview, NoParams> {
  final SellerRepository repository;
  const GetSellerOverview(this.repository);

  @override
  Future<Either<Failure, SellerOverview>> call(NoParams params) => repository.getOverview();
}
