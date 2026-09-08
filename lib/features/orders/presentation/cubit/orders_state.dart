part of 'orders_cubit.dart';



enum OrdersStatus { loading, loaded, error }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<Order> orders;
  final String? errorMessage;
  final String? justPlacedOrderId;

  const OrdersState({
    this.status = OrdersStatus.loading,
    this.orders = const [],
    this.errorMessage,
    this.justPlacedOrderId,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    String? errorMessage,
    String? justPlacedOrderId,
    bool clearJustPlaced = false,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      justPlacedOrderId: clearJustPlaced ? null : (justPlacedOrderId ?? this.justPlacedOrderId),
    );
  }

  Order? byId(String id) => orders.where((o) => o.id == id).firstOrNull;

  @override
  List<Object?> get props => [status, orders, errorMessage, justPlacedOrderId];
}
