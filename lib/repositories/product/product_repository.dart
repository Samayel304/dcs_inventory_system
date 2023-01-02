import 'dart:io';

import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/repositories/product/base_product_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;
  final firebase_storage.FirebaseStorage _firebaseStorage;
  ProductRepository(
      {FirebaseFirestore? firebaseFirestore,
      firebase_storage.FirebaseStorage? firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage =
            firebaseStorage ?? firebase_storage.FirebaseStorage.instance;

  @override
  FutureVoid createProduct(Product product, File image) async {
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
          _firebaseStorage
              .ref('product_image/${basename(image.path)}')
              .putFile(File(image.path))
              .then((_) async {
        String downLoadUrl = await getDownloadURL(basename(image.path));
        Product productToBeSave =
            product.copyWith(productImageUrl: downLoadUrl);
        _firebaseFirestore
            .collection("products")
            .add(productToBeSave.toDocument());
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid editProductDetails(Product product, File? image) async {
    try {
      var productDoc = await _firebaseFirestore
          .collection("products")
          .where('productName', isEqualTo: product.productName.toLowerCase())
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
      }).first;

      if (productDoc.isNotEmpty &&
          productDoc.first.productId != product.productId) {
        throw 'Product with the same name already exists!';
      }
      return right(image != null
          ? _firebaseStorage
              .ref('product_image/${basename(image.path)}')
              .putFile(File(image.path))
              .then((_) async {
              String downLoadUrl = await getDownloadURL(basename(image.path));
              Product productToBeSave =
                  product.copyWith(productImageUrl: downLoadUrl);
              _firebaseFirestore
                  .collection("products")
                  .doc(productToBeSave.productId)
                  .update(productToBeSave.toDocument());
            })
          : _firebaseFirestore
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

  @override
  FutureVoid deductProductQuantity(Product product) async {
    try {
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
  FutureVoid addProductQuantity(Product product) async {
    try {
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
  Stream<List<Product>> searchProduct(String query) {
    return _firebaseFirestore
        .collection('products')
        .where(
          'productName',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              return Product.fromSnapshot(doc);
            }).toList());
  }

  Future<String> getDownloadURL(String imageName) async {
    String downloadURL =
        await _firebaseStorage.ref('product_image/$imageName').getDownloadURL();
    return downloadURL;
  }
}
