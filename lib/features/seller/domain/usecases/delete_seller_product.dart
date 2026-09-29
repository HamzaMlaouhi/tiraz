import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/seller_repository.dart';

class DeleteSellerProduct implements UseCase<Unit, String> {
  final SellerRepository repository;
  const DeleteSellerProduct(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) => repository.deleteProduct(id);
}
