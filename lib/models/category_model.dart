import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? categoryId;
  final String categoryName;
  final DateTime dateCreated;

  const Category(
      {this.categoryId, required this.categoryName, required this.dateCreated});

  Category copyWith(
      {String? categoryId, String? categoryName, DateTime? dateCreated}) {
    return Category(
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        dateCreated: dateCreated ?? this.dateCreated);
  }

  factory Category.fromSnapshot(DocumentSnapshot snap) {
    return Category(
        categoryId: snap.id,
        categoryName: snap['categoryName'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()));
  }

  factory Category.fromSupplierSnapshot(Map<String, dynamic> snap) {
    return Category(
        categoryName: snap['categoryName'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()));
  }

  Map<String, dynamic> toDocument() {
    return {
      'dateCreated': dateCreated,
      'categoryName': categoryName,
    };
  }

  @override
  List<Object?> get props => [categoryId, categoryName];
}
