import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_snapshot.dart';
import '../../domain/usecases/add_custom_items_to_cart.dart';
import '../../domain/usecases/add_product_to_cart.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/remove_cart_item.dart';
import '../../domain/usecases/set_gift_wrap.dart';

part 'cart_state.dart';

/// App-wide cart, backed by the server's per-user cart. Registered as a
/// lazy singleton so the Home badge, Product's "add to cart", and Checkout
/// all share one instance.
///
/// Adds wait for the server (it prices the line); removals and the
/// gift-wrap toggle are optimistic and roll back on failure. Mutations
/// return the failure message, or null on success.
class CartCubit extends Cubit<CartState> {
  final GetCart _getCart;
  final AddProductToCart _addProductToCart;
  final AddCustomItemsToCart _addCustomItemsToCart;
  final RemoveCartItem _removeCartItem;
  final SetGiftWrap _setGiftWrap;

  CartCubit({
    required GetCart getCart,
    required AddProductToCart addProductToCart,
    required AddCustomItemsToCart addCustomItemsToCart,
    required RemoveCartItem removeCartItem,
    required SetGiftWrap setGiftWrap,
  })  : _getCart = getCart,
        _addProductToCart = addProductToCart,
        _addCustomItemsToCart = addCustomItemsToCart,
        _removeCartItem = removeCartItem,
        _setGiftWrap = setGiftWrap,
        super(const CartState());

  Future<void> load() async {
    if (state.status != CartStatus.loaded) emit(state.copyWith(status: CartStatus.loading));
    final result = await _getCart(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: CartStatus.error, errorMessage: failure.message)),
      (cart) => emit(CartState(
        status: CartStatus.loaded,
        items: cart.items,
        giftWrap: cart.giftWrap,
        shippingAed: cart.shippingAed,
        delivery: cart.delivery,
      )),
    );
  }

  Future<String?> addProduct({required String productId, required bool madeToMeasure, LocalizedText? variant}) async {
    final result = await _addProductToCart(
      AddProductToCartParams(productId: productId, madeToMeasure: madeToMeasure, variant: variant),
    );
    return result.fold((failure) => failure.message, (item) {
      emit(state.copyWith(status: CartStatus.loaded, items: [...state.items, item]));
      return null;
    });
  }

  Future<String?> addCustomItems(List<CartItem> items) async {
    final result = await _addCustomItemsToCart(items);
    return result.fold((failure) => failure.message, (added) {
      emit(state.copyWith(status: CartStatus.loaded, items: [...state.items, ...added]));
      return null;
    });
  }

  Future<String?> removeItem(String id) async {
    final previous = state;
    emit(state.copyWith(items: state.items.where((item) => item.id != id).toList()));
    final result = await _removeCartItem(id);
    return result.fold((failure) {
      emit(previous);
      return failure.message;
    }, (_) => null);
  }

  Future<String?> toggleGift() async {
    final next = !state.giftWrap;
    emit(state.copyWith(giftWrap: next));
    final result = await _setGiftWrap(next);
    return result.fold((failure) {
      emit(state.copyWith(giftWrap: !next));
      return failure.message;
    }, (_) => null);
  }

  /// Local reset only — placing an order already empties the cart
  /// server-side, so there is nothing to call.
  void reset() => emit(const CartState(status: CartStatus.loaded));
}
