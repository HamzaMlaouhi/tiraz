part of 'product_cubit.dart';

enum ProductStatus { loading, loaded, error }

enum ProductMode { readyToWear, madeToMeasure }

class ProductState extends Equatable {
  final ProductStatus status;
  final ProductDetail? detail;
  final String? errorMessage;
  final ProductMode mode;
  final int selectedSizeIndex;
  final int selectedProfileIndex;
  final bool addedToCart;

  const ProductState({
    this.status = ProductStatus.loading,
    this.detail,
    this.errorMessage,
    this.mode = ProductMode.readyToWear,
    this.selectedSizeIndex = 1,
    this.selectedProfileIndex = 0,
    this.addedToCart = false,
  });

  ProductState copyWith({
    ProductStatus? status,
    ProductDetail? detail,
    String? errorMessage,
    ProductMode? mode,
    int? selectedSizeIndex,
    int? selectedProfileIndex,
    bool? addedToCart,
  }) {
    return ProductState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      errorMessage: errorMessage ?? this.errorMessage,
      mode: mode ?? this.mode,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
      selectedProfileIndex: selectedProfileIndex ?? this.selectedProfileIndex,
      addedToCart: addedToCart ?? this.addedToCart,
    );
  }

  @override
  List<Object?> get props =>
      [status, detail, errorMessage, mode, selectedSizeIndex, selectedProfileIndex, addedToCart];
}
