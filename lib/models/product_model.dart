import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/utils/constants.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? productId;
  final String productName;
  final int quantity;
  final String category;
  final DateTime dateCreated;
  final bool isNew;
  final String productImageUrl;
  final String lifeSpan;
  final double unitPrice;
  final double totalExpenses;

  const Product(
      {this.productId,
      this.productName = "",
      this.quantity = 0,
      this.category = "",
      required this.dateCreated,
      this.isNew = true,
      this.productImageUrl = Constant.defaultProductImageUrl,
      this.lifeSpan = "",
      this.unitPrice = 0,
      this.totalExpenses = 0});

  Product copyWith(
      {String? productId,
      String? productName,
      int? quantity,
      String? category,
      double? unitPrice,
      DateTime? dateCreated,
      bool? isNew,
      String? productImageUrl,
      String? lifeSpan,
      double? totalExpenses}) {
    return Product(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        category: category ?? this.category,
        dateCreated: dateCreated ?? this.dateCreated,
        isNew: isNew ?? this.isNew,
        productImageUrl: productImageUrl ?? this.productImageUrl,
        lifeSpan: lifeSpan ?? this.lifeSpan,
        unitPrice: unitPrice ?? this.unitPrice,
        totalExpenses: totalExpenses ?? this.totalExpenses);
  }

  factory Product.fromSnapshot(DocumentSnapshot snap) {
    return Product(
        productId: snap.id,
        productName: snap['productName'],
        quantity: snap['quantity'],
        category: snap['category'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()),
        isNew: snap['isNew'],
        productImageUrl: snap['productImageUrl'],
        lifeSpan: snap['lifeSpan'],
        unitPrice: double.parse(snap['unitPrice'].toString()),
        totalExpenses: double.parse(snap['totalExpenses'].toString()));
  }

  factory Product.fromOrderSnapshot(Map<String, dynamic> snap) {
    return Product(
        productId: snap['productId'],
        productName: snap['productName'],
        quantity: snap['quantity'],
        category: snap['category'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()),
        isNew: snap['isNew'],
        unitPrice: double.parse(snap['unitPrice'].toString()),
        totalExpenses: double.parse(snap['totalExpenses'].toString()));
  }

  Map<String, Object> toDocument() {
    return {
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'dateCreated': dateCreated,
      'isNew': isNew,
      'productImageUrl': productImageUrl,
      'lifeSpan': lifeSpan,
      'unitPrice': unitPrice,
      'totalExpenses': totalExpenses
    };
  }

  Map<String, Object> toOrderDocument() {
    return {
      'productId': productId.toString(),
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'dateCreated': dateCreated,
      'isNew': isNew,
      'unitPrice': unitPrice,
      'totalExpenses': totalExpenses
    };
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        quantity,
        category,
        dateCreated,
        isNew,
        productImageUrl,
        lifeSpan,
        unitPrice,
        totalExpenses
      ];
}
