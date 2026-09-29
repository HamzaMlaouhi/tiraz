import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlist implements UseCase<List<WishlistItem>, NoParams> {
  final WishlistRepository repository;
  const GetWishlist(this.repository);

  @override
  Future<Either<Failure, List<WishlistItem>>> call(NoParams params) => repository.getWishlist();
}
