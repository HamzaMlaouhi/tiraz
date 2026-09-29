import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_summary.dart';
import '../repositories/recently_viewed_repository.dart';

class GetRecentlyViewed implements UseCase<List<ProductSummary>, NoParams> {
  final RecentlyViewedRepository repository;
  const GetRecentlyViewed(this.repository);

  @override
  Future<Either<Failure, List<ProductSummary>>> call(NoParams params) => repository.getRecentlyViewed();
}

/// Records that the user opened [ProductSummary]; returns the updated list.
class RecordProductView implements UseCase<List<ProductSummary>, ProductSummary> {
  final RecentlyViewedRepository repository;
  const RecordProductView(this.repository);

  @override
  Future<Either<Failure, List<ProductSummary>>> call(ProductSummary product) => repository.record(product);
}

class ClearRecentlyViewed implements UseCase<Unit, NoParams> {
  final RecentlyViewedRepository repository;
  const ClearRecentlyViewed(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) => repository.clear();
}
