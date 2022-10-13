import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? productId;
  late String productName;
  final int quantity;
  final String category;
  final double unitPrice;

  Product(
      {this.productId,
      this.productName = "",
      this.quantity = 0,
      this.category = "",
      this.unitPrice = 0});

  Product copyWith({
    String? productId,
    String? productName,
    int? quantity,
    String? category,
    double? unitPrice,
  }) {
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  factory Product.fromSnapshot(DocumentSnapshot snap) {
    return Product(
      productId: snap.id,
      productName: snap['productName'],
      quantity: snap['quantity'],
      category: snap['category'],
      unitPrice: double.parse(snap['unitPrice'].toString()),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'unitPrice': unitPrice,
    };
  }


}
