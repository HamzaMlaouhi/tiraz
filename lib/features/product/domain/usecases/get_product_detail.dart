import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_detail.dart';
import '../repositories/product_repository.dart';

class GetProductDetail implements UseCase<ProductDetail, String> {
  final ProductRepository repository;
  const GetProductDetail(this.repository);

  @override
  Future<Either<Failure, ProductDetail>> call(String id) => repository.getProductDetail(id);
}
