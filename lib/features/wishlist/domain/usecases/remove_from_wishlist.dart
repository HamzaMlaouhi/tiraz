import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/wishlist_repository.dart';

/// Params: the wishlist entry id (not the product id).
class RemoveFromWishlist implements UseCase<Unit, String> {
  final WishlistRepository repository;
  const RemoveFromWishlist(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) => repository.remove(id);
}
