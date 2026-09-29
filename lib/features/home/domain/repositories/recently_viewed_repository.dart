import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_summary.dart';

abstract class RecentlyViewedRepository {
  Future<Either<Failure, List<ProductSummary>>> getRecentlyViewed();
  Future<Either<Failure, List<ProductSummary>>> record(ProductSummary product);
  Future<Either<Failure, Unit>> clear();
}
