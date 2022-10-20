import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/model.dart';

class Order {
  final String? orderId;
  final DateTime dateReceived;
  final Product product;
  final DateTime orderedDate;
  final int quantity;
  final String status;

  Order(
      {this.orderId,
      required this.dateReceived,
      required this.product,
      required this.orderedDate,
      this.quantity = 0,
      required this.status});

  Order copyWith(
      {String? orderId,
      Product? product,
      int? quantity,
      String? status,
      DateTime? orderedDate,
      DateTime? dateReceived}) {
    return Order(
        orderId: orderId ?? this.orderId,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        status: status ?? this.status,
        orderedDate: orderedDate ?? this.orderedDate,
        dateReceived: dateReceived ?? this.dateReceived);
  }

  factory Order.fromSnapshot(DocumentSnapshot snap) {
    return Order(
      orderId: snap.id,
      product: Product.fromOrderSnapshot(snap['product']),
      quantity: snap['quantity'],
      status: snap['status'],
      orderedDate: DateTime.parse(
          ((snap['orderedDate']) as Timestamp).toDate().toString()),
      dateReceived: DateTime.parse(
          ((snap['dateReceived']) as Timestamp).toDate().toString()),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'product': product.toOrderDocument(),
      'quantity': quantity,
      'status': status,
      'orderedDate': orderedDate,
      'dateReceived': dateReceived
    };
  }
}
