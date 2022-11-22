import 'package:dcs_inventory_system/models/product_model.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';

abstract class BaseProductRepository {
  Stream<List<Product>> getAllProducts();
  FutureVoid createProduct(Product product);
  FutureVoid editProductDetails(Product product);
  FutureVoid deductProductQuantity(Product product);
  FutureVoid deleteProduct(Product product);
  Future<void> deleteProductByCategory(String category);
  Future<void> updateProductCategory(String category, String newCategory);
}
