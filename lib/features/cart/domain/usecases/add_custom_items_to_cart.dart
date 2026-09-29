import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Adds non-catalog lines (e.g. a family set) in one batch.
class AddCustomItemsToCart implements UseCase<List<CartItem>, List<CartItem>> {
  final CartRepository repository;
  const AddCustomItemsToCart(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(List<CartItem> items) => repository.addCustomItems(items);
}
