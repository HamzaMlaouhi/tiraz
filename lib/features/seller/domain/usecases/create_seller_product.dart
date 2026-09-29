import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/new_seller_product.dart';
import '../entities/seller_product.dart';
import '../repositories/seller_repository.dart';

/// Uploads the device photo first when there is one, then creates the listing.
class CreateSellerProduct implements UseCase<SellerProduct, NewSellerProduct> {
  final SellerRepository repository;
  const CreateSellerProduct(this.repository);

  @override
  Future<Either<Failure, SellerProduct>> call(NewSellerProduct product) => repository.createProduct(product);
}
