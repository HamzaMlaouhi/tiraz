import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistDataSource remoteDataSource;
  const WishlistRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<WishlistItem>>> getWishlist() async {
    try {
      return Right(await remoteDataSource.getWishlist());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, WishlistItem>> add(String productId) async {
    try {
      return Right(await remoteDataSource.add(productId));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> remove(String id) async {
    try {
      await remoteDataSource.remove(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
