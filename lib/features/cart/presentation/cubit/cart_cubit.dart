import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';

part 'cart_state.dart';

/// App-wide cart. Registered as a lazy singleton so the Home badge,
/// Product's "add to cart", and Checkout all share one instance.
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(CartItem item) => emit(state.copyWith(items: [...state.items, item]));

  void addItems(Iterable<CartItem> items) => emit(state.copyWith(items: [...state.items, ...items]));

  void toggleGift() => emit(state.copyWith(giftWrap: !state.giftWrap));

  void clear() => emit(const CartState());
}
