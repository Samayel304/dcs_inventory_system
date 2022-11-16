import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/model.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String? orderId;
  final DateTime dateReceived;
  final Product product;
  final DateTime orderedDate;
  final DateTime dateCancelled;
  final int quantity;
  final String status;
  final Supplier supplier;

  const OrderModel(
      {this.orderId,
      required this.dateReceived,
      required this.product,
      required this.orderedDate,
      this.quantity = 0,
      required this.status,
      required this.supplier,
      required this.dateCancelled});

  OrderModel copyWith(
      {String? orderId,
      Product? product,
      int? quantity,
      String? status,
      DateTime? orderedDate,
      DateTime? dateReceived,
      Supplier? supplier,
      DateTime? dateCancelled}) {
    return OrderModel(
        orderId: orderId ?? this.orderId,
        product: product ?? this.product,
        quantity: quantity ?? this.quantity,
        status: status ?? this.status,
        orderedDate: orderedDate ?? this.orderedDate,
        dateReceived: dateReceived ?? this.dateReceived,
        supplier: supplier ?? this.supplier,
        dateCancelled: dateCancelled ?? this.dateCancelled);
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snap) {
    return OrderModel(
      orderId: snap.id,
      product: Product.fromOrderSnapshot(snap['product']),
      quantity: snap['quantity'],
      status: snap['status'],
      orderedDate: DateTime.parse(
          ((snap['orderedDate']) as Timestamp).toDate().toString()),
      dateReceived: DateTime.parse(
          ((snap['dateReceived']) as Timestamp).toDate().toString()),
      dateCancelled: DateTime.parse(
          ((snap['dateCancelled']) as Timestamp).toDate().toString()),
      supplier: Supplier.fromOrderSnapshot(snap['supplier']),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'product': product.toOrderDocument(),
      'quantity': quantity,
      'status': status,
      'orderedDate': orderedDate,
      'dateReceived': dateReceived,
      'dateCancelled': dateCancelled,
      'supplier': supplier.toOrderDocument()
    };
  }

  @override
  List<Object?> get props =>
      [orderId, product, quantity, status, orderedDate, dateReceived];
}
