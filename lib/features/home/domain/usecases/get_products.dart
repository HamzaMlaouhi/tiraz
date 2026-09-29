import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_summary.dart';
import '../repositories/home_repository.dart';

class GetProducts implements UseCase<List<ProductSummary>, ProductQuery> {
  final HomeRepository repository;
  const GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductSummary>>> call(ProductQuery params) =>
      repository.getProducts(search: params.search, sellerId: params.sellerId);
}

class ProductQuery extends Equatable {
  final String? search;
  final String? sellerId;

  const ProductQuery({this.search, this.sellerId});

  @override
  List<Object?> get props => [search, sellerId];
}
