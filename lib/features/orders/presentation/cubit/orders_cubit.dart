import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/list_extensions.dart';
import '../../../../core/value_objects/localized_text.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders.dart';

part 'orders_state.dart';

/// Registered as a lazy singleton: Checkout appends a freshly placed
/// order here, and the Orders tab reads the same list straight back —
/// no round trip through a "backend" needed for an in-memory MVP.
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders _getOrders;
  int _nextOrderSeq = 2842;

  OrdersCubit({required GetOrders getOrders}) : _getOrders = getOrders, super(const OrdersState());

  Future<void> load() async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _getOrders(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: OrdersStatus.error, errorMessage: failure.message)),
      (orders) => emit(state.copyWith(status: OrdersStatus.loaded, orders: orders)),
    );
  }

  /// Places a new order for one line item and returns its id.
  String placeOrder({
    required LocalizedText itemName,
    required LocalizedText sellerMeta,
    required List<Color> imageGradient,
  }) {
    final id = 'TRZ-${_nextOrderSeq++}';
    final order = OrderModel.justPlaced(
      id: id,
      itemName: itemName,
      sellerMeta: sellerMeta,
      imageGradient: imageGradient,
    );
    emit(state.copyWith(orders: [order, ...state.orders], justPlacedOrderId: id));
    return id;
  }

  void acknowledgePlacement() => emit(state.copyWith(clearJustPlaced: true));
}
