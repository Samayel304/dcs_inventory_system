import 'package:dcs_inventory_system/utils/type_def.dart';

import 'package:dcs_inventory_system/models/order_model.dart';

abstract class BaseOrderRepository {
  Stream<List<OrderModel>> getAllOrders();
  FutureVoid addOrder(OrderModel order);
  FutureVoid editOrderDetails(OrderModel order);
}
