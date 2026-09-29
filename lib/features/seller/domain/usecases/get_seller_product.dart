import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/seller_product.dart';
import '../repositories/seller_repository.dart';

class GetSellerProduct implements UseCase<SellerProduct, String> {
  final SellerRepository repository;
  const GetSellerProduct(this.repository);

  @override
  Future<Either<Failure, SellerProduct>> call(String id) => repository.getProduct(id);
}
