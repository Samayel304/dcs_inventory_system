import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/category_model.dart';
import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String? supplierId;
  final String supplierName;
  final String contactPerson;
  final String address;
  final String contactNumber;
  final String category;
  final DateTime dateCreated;

  const Supplier(
      {required this.supplierName,
      required this.contactPerson,
      required this.address,
      required this.contactNumber,
      this.supplierId,
      required this.category,
      required this.dateCreated});

  Supplier copyWith(
      {String? supplierId,
      String? supplierName,
      String? address,
      String? contactNumber,
      String? contactPerson,
      DateTime? dateCreated,
      String? category}) {
    return Supplier(
        supplierId: supplierId ?? this.supplierId,
        supplierName: supplierName ?? this.supplierName,
        contactPerson: contactPerson ?? this.contactPerson,
        address: address ?? this.address,
        contactNumber: contactNumber ?? this.contactNumber,
        dateCreated: dateCreated ?? this.dateCreated,
        category: category ?? this.category);
  }

  factory Supplier.fromSnapshot(DocumentSnapshot snap) {
    return Supplier(
        supplierId: snap.id,
        supplierName: snap['supplierName'],
        contactPerson: snap['contactPerson'],
        address: snap['address'],
        contactNumber: snap['contactNumber'],
        category: snap['category'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()));
  }

  factory Supplier.fromOrderSnapshot(Map<String, dynamic> snap) {
    return Supplier(
        category: snap['category'],
        supplierId: snap['supplierId'],
        supplierName: snap['supplierName'],
        contactPerson: snap['contactPerson'],
        address: snap['address'],
        contactNumber: snap['contactNumber'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()));
  }

  Map<String, Object> toDocument() {
    return {
      'supplierName': supplierName,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'address': address,
      'dateCreated': dateCreated,
      'category': category
    };
  }

  Map<String, Object> toOrderDocument() {
    return {
      'supplierId': supplierId.toString(),
      'supplierName': supplierName,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'address': address,
      'dateCreated': dateCreated,
      'category': category
    };
  }

  @override
  List<Object?> get props => [
        supplierName,
        contactNumber,
        contactPerson,
        address,
        contactNumber,
        dateCreated,
        category
      ];
}
