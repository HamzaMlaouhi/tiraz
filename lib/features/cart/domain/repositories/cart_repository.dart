import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../entities/cart_item.dart';
import '../entities/cart_snapshot.dart';

abstract class CartRepository {
  Future<Either<Failure, CartSnapshot>> getCart();
  Future<Either<Failure, CartItem>> addProduct({
    required String productId,
    required bool madeToMeasure,
    LocalizedText? variant,
  });
  Future<Either<Failure, List<CartItem>>> addCustomItems(List<CartItem> items);
  Future<Either<Failure, Unit>> removeItem(String id);
  Future<Either<Failure, Unit>> setGiftWrap(bool giftWrap);
  Future<Either<Failure, Unit>> clear();
}
