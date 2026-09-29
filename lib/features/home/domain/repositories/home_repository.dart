import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/home_data.dart';
import '../entities/product_summary.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData();
  Future<Either<Failure, List<ProductSummary>>> getProducts({String? search, String? sellerId});
}
