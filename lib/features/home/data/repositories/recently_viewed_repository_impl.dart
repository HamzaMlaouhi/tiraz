import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_summary.dart';
import '../../domain/repositories/recently_viewed_repository.dart';
import '../datasources/recently_viewed_local_data_source.dart';

class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  final RecentlyViewedDataSource localDataSource;
  const RecentlyViewedRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ProductSummary>>> getRecentlyViewed() => _run(localDataSource.getRecentlyViewed);

  @override
  Future<Either<Failure, List<ProductSummary>>> record(ProductSummary product) =>
      _run(() => localDataSource.record(product));

  @override
  Future<Either<Failure, Unit>> clear() => _run(() async {
        await localDataSource.clear();
        return unit;
      });

  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
