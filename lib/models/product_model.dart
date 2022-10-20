import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? productId;
  late String productName;
  final int quantity;
  final String category;
  final double unitPrice;
  final DateTime dateCreated;

  Product(
      {this.productId,
      this.productName = "",
      this.quantity = 0,
      this.category = "",
      this.unitPrice = 0,
      required this.dateCreated});

  Product copyWith(
      {String? productId,
      String? productName,
      int? quantity,
      String? category,
      double? unitPrice,
      DateTime? dateCreated}) {
    return Product(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        category: category ?? this.category,
        unitPrice: unitPrice ?? this.unitPrice,
        dateCreated: dateCreated ?? this.dateCreated);
  }

  factory Product.fromSnapshot(DocumentSnapshot snap) {
    return Product(
      productId: snap.id,
      productName: snap['productName'],
      quantity: snap['quantity'],
      category: snap['category'],
      unitPrice: double.parse(snap['unitPrice'].toString()),
      dateCreated: DateTime.parse(
          ((snap['dateCreated']) as Timestamp).toDate().toString()),
    );
  }

  factory Product.fromOrderSnapshot(Map<String, dynamic> snap) {
    return Product(
      productId: snap['productId'],
      productName: snap['productName'],
      quantity: snap['quantity'],
      category: snap['category'],
      unitPrice: double.parse(snap['unitPrice'].toString()),
      dateCreated: DateTime.parse(
          ((snap['dateCreated']) as Timestamp).toDate().toString()),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'unitPrice': unitPrice,
      'dateCreated': dateCreated
    };
  }

  Map<String, Object> toOrderDocument() {
    return {
      'productId': productId.toString(),
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'unitPrice': unitPrice,
      'dateCreated': dateCreated
    };
  }
}
