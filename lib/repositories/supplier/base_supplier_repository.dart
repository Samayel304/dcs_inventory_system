import '../../models/model.dart';

abstract class BaseSupplierRepository {
  Stream<List<Supplier>> getAllSuppliers();
  Future<void> addSupplier(Supplier supplier);
  Future<void> editSupplier(Supplier supplier);
  Future<void> deleteSupplier(Supplier supplier);
}
