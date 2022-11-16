import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/repositories/order/base_order_repository.dart';
import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:fpdart/fpdart.dart';

class OrderRepository extends BaseOrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  FutureVoid addOrder(OrderModel order) async {
    try {
      // ignore: void_checks
      return right(
          // ignore: void_checks
          _firebaseFirestore.collection("orders").add(order.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid editOrderDetails(OrderModel order) async {
    try {
      return right(_firebaseFirestore
          .collection("orders")
          .doc(order.orderId)
          .update(order.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<OrderModel>> getAllOrders() {
    return _firebaseFirestore
        .collection('orders')
        .orderBy('orderedDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    });
  }
}
