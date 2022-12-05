import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/supplier_model.dart';
import 'package:dcs_inventory_system/repositories/supplier/base_supplier_repository.dart';
import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:fpdart/fpdart.dart';

class SupplierRepository extends BaseSupplierRepository {
  final FirebaseFirestore _firebaseFirestore;

  SupplierRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  FutureVoid addSupplier(Supplier supplier) async {
    try {
      return right(
          // ignore: void_checks
          _firebaseFirestore.collection('supplier').add(supplier.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid editSupplier(Supplier supplier) async {
    try {
      return right(_firebaseFirestore
          .collection("supplier")
          .doc(supplier.supplierId)
          .update(supplier.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
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
  FutureVoid deleteSupplier(Supplier supplier) async {
    try {
      return right(_firebaseFirestore
          .collection('supplier')
          .doc(supplier.supplierId)
          .delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<void> deleteSupplierByCategory(String category) async {
    try {
      /*    var docs = await _firebaseFirestore
          .collection('products')
          .where('category', isEqualTo: category.toLowerCase())
          .get()
          .then((snapshot) =>
              snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());

      Future.wait(docs.map((product) {
        return deleteProduct(product);
      })); */
      WriteBatch batch = _firebaseFirestore.batch();
      return await _firebaseFirestore
          .collection('supplier')
          .where('category', isEqualTo: category.toLowerCase())
          .get()
          .then((res) {
        for (var doc in res.docs) {
          batch.delete(doc.reference);
        }
        return batch.commit();
      });
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      e.toString();
    }
  }
}
