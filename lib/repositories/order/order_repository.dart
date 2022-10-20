import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/order_model.dart';
import 'package:dcs_inventory_system/repositories/order/base_order_repository.dart';

class OrderRepository extends BaseOrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addOrder(Order order) async {
    await _firebaseFirestore.collection("orders").add(order.toDocument());
  }

  @override
  Future<void> editOrderDetails(Order order) async {
    await _firebaseFirestore
        .collection("orders")
        .doc(order.orderId)
        .update(order.toDocument());
  }

  @override
  Stream<List<Order>> getAllOrders() {
    return _firebaseFirestore
        .collection('orders')
        .orderBy('orderedDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Order.fromSnapshot(doc)).toList();
    });
  }
}
