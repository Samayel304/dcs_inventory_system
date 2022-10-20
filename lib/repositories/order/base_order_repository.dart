import '../../models/order_model.dart';

abstract class BaseOrderRepository {
  Stream<List<Order>> getAllOrders();
  Future<void> addOrder(Order order);
  Future<void> editOrderDetails(Order order);
}
