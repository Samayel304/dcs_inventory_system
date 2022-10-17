import '../../models/product_model.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
  Future<void> createProduct(Product product);
  Future<void> editProductDetails(Product product);
}
