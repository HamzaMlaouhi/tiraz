import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddProductToCart implements UseCase<CartItem, AddProductToCartParams> {
  final CartRepository repository;
  const AddProductToCart(this.repository);

  @override
  Future<Either<Failure, CartItem>> call(AddProductToCartParams params) => repository.addProduct(
        productId: params.productId,
        madeToMeasure: params.madeToMeasure,
        variant: params.variant,
      );
}

class AddProductToCartParams extends Equatable {
  final String productId;
  final bool madeToMeasure;
  final LocalizedText? variant;

  const AddProductToCartParams({required this.productId, required this.madeToMeasure, this.variant});

  @override
  List<Object?> get props => [productId, madeToMeasure, variant];
}
