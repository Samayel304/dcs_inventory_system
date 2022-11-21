import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/repositories/product/base_product_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';

import 'package:fpdart/fpdart.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  FutureVoid createProduct(Product product) async {
    try {
      var productDoc = await _firebaseFirestore
          .collection("products")
          .where('productName', isEqualTo: product.productName.toLowerCase())
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      }).first;

      if (productDoc.isNotEmpty) {
        throw 'Product with the same name already exists!';
      }
      return right(
          // ignore: void_checks
          _firebaseFirestore.collection("products").add(product.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid editProductDetails(Product product) async {
    try {
      var productDoc = await _firebaseFirestore
          .collection("products")
          .where('productName', isEqualTo: product.productName.toLowerCase())
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      }).first;

      if (productDoc.isNotEmpty) {
        throw 'Product with the same name already exists!';
      }
      return right(_firebaseFirestore
          .collection("products")
          .doc(product.productId)
          .update(product.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection("products")
        .orderBy('dateCreated')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  @override
  FutureVoid deleteProduct(Product product) async {
    try {
      return right(_firebaseFirestore
          .collection('products')
          .doc(product.productId)
          .delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<void> deleteProductByCategory(String category) async {
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
          .collection('products')
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

  @override
  Future<void> updateProductCategory(
      String category, String newCategory) async {
    try {
      WriteBatch batch = _firebaseFirestore.batch();
      return await _firebaseFirestore
          .collection('products')
          .where('category', isEqualTo: category.toLowerCase())
          .get()
          .then((res) {
        for (var doc in res.docs) {
          batch.update(doc.reference, {'category': newCategory});
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
