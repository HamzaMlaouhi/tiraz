import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_detail.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductDetail>> getProductDetail(String id);
}
