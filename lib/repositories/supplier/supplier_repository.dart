import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/supplier_model.dart';
import 'package:dcs_inventory_system/repositories/supplier/base_supplier_repository.dart';

class SupplierRepository extends BaseSupplierRepository {
  final FirebaseFirestore _firebaseFirestore;

  SupplierRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Future<void> addSupplier(Supplier supplier) async {
    await _firebaseFirestore.collection('supplier').add(supplier.toDocument());
  }

  @override
  Future<void> editSupplier(Supplier supplier) async {
    await _firebaseFirestore
        .collection("supplier")
        .doc(supplier.supplierId)
        .update(supplier.toDocument());
  }

  @override
  Stream<List<Supplier>> getAllSuppliers() {
    return _firebaseFirestore
        .collection('supplier')
        .orderBy('dateCreated')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Supplier.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> deleteSupplier(Supplier supplier) async {
    await _firebaseFirestore
        .collection('supplier')
        .doc(supplier.supplierId)
        .delete();
  }
}
