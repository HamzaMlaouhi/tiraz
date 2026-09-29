import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_summary.dart';
import '../../domain/usecases/get_products.dart';

enum ProductListStatus { idle, loading, loaded, error }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<ProductSummary> products;

  const ProductListState({this.status = ProductListStatus.idle, this.products = const []});

  @override
  List<Object?> get props => [status, products];
}

/// A server-backed product list: home search results ([search], debounced
/// per keystroke) or one store's full catalog ([loadSeller]). Registered
/// as a factory — each search box / store sheet owns its own instance.
class ProductListCubit extends Cubit<ProductListState> {
  static const _debounce = Duration(milliseconds: 300);

  final GetProducts _getProducts;
  Timer? _debounceTimer;
  ProductQuery? _latestQuery;

  ProductListCubit({required GetProducts getProducts})
      : _getProducts = getProducts,
        super(const ProductListState());

  void search(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _latestQuery = null;
      emit(const ProductListState());
      return;
    }
    emit(ProductListState(status: ProductListStatus.loading, products: state.products));
    _debounceTimer = Timer(_debounce, () => _load(ProductQuery(search: trimmed)));
  }

  Future<void> loadSeller(String sellerId) {
    emit(ProductListState(status: ProductListStatus.loading, products: state.products));
    return _load(ProductQuery(sellerId: sellerId));
  }

  Future<void> _load(ProductQuery query) async {
    _latestQuery = query;
    final result = await _getProducts(query);
    // Drop responses for queries the user has already typed past.
    if (isClosed || query != _latestQuery) return;
    result.fold(
      (_) => emit(ProductListState(status: ProductListStatus.error, products: state.products)),
      (products) => emit(ProductListState(status: ProductListStatus.loaded, products: products)),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
