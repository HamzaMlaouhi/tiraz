import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_detail.dart';
import '../../domain/usecases/get_product_detail.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductDetail _getProductDetail;

  ProductCubit({required GetProductDetail getProductDetail})
      : _getProductDetail = getProductDetail,
        super(const ProductState());

  Future<void> load(String id) async {
    emit(state.copyWith(status: ProductStatus.loading));
    final result = await _getProductDetail(id);
    result.fold(
      (failure) => emit(state.copyWith(status: ProductStatus.error, errorMessage: failure.message)),
      (detail) => emit(state.copyWith(status: ProductStatus.loaded, detail: detail)),
    );
  }

  void setMode(ProductMode mode) => emit(state.copyWith(mode: mode));

  void selectSize(int index) => emit(state.copyWith(selectedSizeIndex: index));

  void selectProfile(int index) => emit(state.copyWith(selectedProfileIndex: index));

  void addToCart() => emit(state.copyWith(addedToCart: true));
}
