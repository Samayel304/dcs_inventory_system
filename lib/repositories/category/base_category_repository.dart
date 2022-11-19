import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';

abstract class BaseCategoryRepository {
  Stream<List<Category>> getAllCategory();
  FutureVoid createCategory(Category category);
}
