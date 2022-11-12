import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? productId;
  final String productName;
  final int quantity;
  final String category;
  final DateTime dateCreated;
  final bool isNew;

  const Product(
      {this.productId,
      this.productName = "",
      this.quantity = 0,
      this.category = "",
      required this.dateCreated,
      this.isNew = false});

  Product copyWith(
      {String? productId,
      String? productName,
      int? quantity,
      String? category,
      double? unitPrice,
      DateTime? dateCreated,
      bool? isNew}) {
    return Product(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        category: category ?? this.category,
        dateCreated: dateCreated ?? this.dateCreated,
        isNew: isNew ?? this.isNew);
  }

  factory Product.fromSnapshot(DocumentSnapshot snap) {
    return Product(
        productId: snap.id,
        productName: snap['productName'],
        quantity: snap['quantity'],
        category: snap['category'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()),
        isNew: snap['isNew']);
  }

  factory Product.fromOrderSnapshot(Map<String, dynamic> snap) {
    return Product(
        productId: snap['productId'],
        productName: snap['productName'],
        quantity: snap['quantity'],
        category: snap['category'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()),
        isNew: snap['isNew']);
  }

  Map<String, Object> toDocument() {
    return {
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'dateCreated': dateCreated,
      'isNew': isNew
    };
  }

  Map<String, Object> toOrderDocument() {
    return {
      'productId': productId.toString(),
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'dateCreated': dateCreated,
      'isNew': isNew
    };
  }

  @override
  List<Object?> get props =>
      [productId, productName, quantity, category, dateCreated, isNew];
}
