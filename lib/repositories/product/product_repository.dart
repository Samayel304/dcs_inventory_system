import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/repositories/product/base_product_repository.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createProduct(Product product) async {
    await _firebaseFirestore.collection("products").add(product.toDocument());
  }

  @override
  Future<void> editProductDetails(Product product) async {
    await _firebaseFirestore
        .collection("products")
        .doc(product.productId)
        .update(product.toDocument());
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
  Future<void> deleteProduct(Product product) async {
    await _firebaseFirestore
        .collection('products')
        .doc(product.productId)
        .delete();
  }
}
