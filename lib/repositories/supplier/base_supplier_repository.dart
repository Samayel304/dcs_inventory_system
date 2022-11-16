import 'package:dcs_inventory_system/utils/type_def.dart';

import '../../models/model.dart';

abstract class BaseSupplierRepository {
  Stream<List<Supplier>> getAllSuppliers();
  FutureVoid addSupplier(Supplier supplier);
  FutureVoid editSupplier(Supplier supplier);
  FutureVoid deleteSupplier(Supplier supplier);
}
