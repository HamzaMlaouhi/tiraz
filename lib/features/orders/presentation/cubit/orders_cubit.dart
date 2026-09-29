import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_order.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/place_order.dart';
import '../../domain/usecases/submit_order_review.dart';

part 'orders_state.dart';

/// Registered as a lazy singleton: Checkout prepends a freshly placed
/// order here, and the Orders tab and Account row read the same list.
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders _getOrders;
  final GetOrder _getOrder;
  final PlaceOrder _placeOrder;
  final SubmitOrderReview _submitOrderReview;

  OrdersCubit({
    required GetOrders getOrders,
    required GetOrder getOrder,
    required PlaceOrder placeOrder,
    required SubmitOrderReview submitOrderReview,
  })  : _getOrders = getOrders,
        _getOrder = getOrder,
        _placeOrder = placeOrder,
        _submitOrderReview = submitOrderReview,
        super(const OrdersState());

  Future<void> load() async {
    if (state.status != OrdersStatus.loaded) emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _getOrders(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: OrdersStatus.error, errorMessage: failure.message)),
      (orders) => emit(state.copyWith(status: OrdersStatus.loaded, orders: orders)),
    );
  }

  /// Refreshes one order (e.g. the detail page opened from a deep link or
  /// before the list has loaded) and merges it into the list. Returns the
  /// failure message, or null on success.
  Future<String?> loadOne(String id) async {
    final result = await _getOrder(id);
    return result.fold((failure) => failure.message, (order) {
      emit(state.copyWith(orders: _upsert(order)));
      return null;
    });
  }

  /// Places an order for the current server-side cart. Returns the new
  /// order id on success, or the failure message.
  Future<({String? orderId, String? error})> placeOrder({
    required String addressId,
    required String paymentMethod,
  }) async {
    final result = await _placeOrder(PlaceOrderParams(addressId: addressId, paymentMethod: paymentMethod));
    return result.fold<({String? orderId, String? error})>(
      (failure) => (orderId: null, error: failure.message),
      (order) {
        emit(state.copyWith(orders: _upsert(order), justPlacedOrderId: order.id));
        return (orderId: order.id, error: null);
      },
    );
  }

  /// Returns the failure message, or null once the review is saved.
  Future<String?> submitReview(String orderId, {required int rating, String? comment}) async {
    final result = await _submitOrderReview(OrderReviewParams(orderId: orderId, rating: rating, comment: comment));
    return result.fold((failure) => failure.message, (order) {
      emit(state.copyWith(orders: _upsert(order)));
      return null;
    });
  }

  void acknowledgePlacement() => emit(state.copyWith(clearJustPlaced: true));

  List<Order> _upsert(Order order) {
    final index = state.orders.indexWhere((o) => o.id == order.id);
    if (index == -1) return [order, ...state.orders];
    return [...state.orders]..[index] = order;
  }
}
