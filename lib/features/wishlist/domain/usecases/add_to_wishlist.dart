import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

/// Params: the product id to save.
class AddToWishlist implements UseCase<WishlistItem, String> {
  final WishlistRepository repository;
  const AddToWishlist(this.repository);

  @override
  Future<Either<Failure, WishlistItem>> call(String productId) => repository.add(productId);
}
