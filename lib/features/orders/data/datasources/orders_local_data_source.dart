import '../models/order_model.dart';

abstract class OrdersLocalDataSource {
  Future<List<OrderModel>> getOrders();
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  @override
  Future<List<OrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return OrderModel.mock();
  }
}
