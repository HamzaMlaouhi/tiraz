import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_snapshot.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDataSource remoteDataSource;
  const CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CartSnapshot>> getCart() => _run(remoteDataSource.getCart);

  @override
  Future<Either<Failure, CartItem>> addProduct({
    required String productId,
    required bool madeToMeasure,
    LocalizedText? variant,
  }) =>
      _run(() => remoteDataSource.addProduct(productId: productId, madeToMeasure: madeToMeasure, variant: variant));

  @override
  Future<Either<Failure, List<CartItem>>> addCustomItems(List<CartItem> items) =>
      _run(() => remoteDataSource.addCustomItems(items));

  @override
  Future<Either<Failure, Unit>> removeItem(String id) => _runUnit(() => remoteDataSource.removeItem(id));

  @override
  Future<Either<Failure, Unit>> setGiftWrap(bool giftWrap) => _runUnit(() => remoteDataSource.setGiftWrap(giftWrap));

  @override
  Future<Either<Failure, Unit>> clear() => _runUnit(remoteDataSource.clear);

  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<Either<Failure, Unit>> _runUnit(Future<void> Function() call) => _run(() async {
        await call();
        return unit;
      });
}
