import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlist();
  Future<Either<Failure, WishlistItem>> add(String productId);
  Future<Either<Failure, Unit>> remove(String id);
}
