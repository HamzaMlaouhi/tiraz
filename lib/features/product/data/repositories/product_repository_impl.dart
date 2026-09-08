import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;
  const ProductRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, ProductDetail>> getProductDetail(String id) async {
    try {
      final detail = await localDataSource.getProductDetail(id);
      return Right(detail);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
