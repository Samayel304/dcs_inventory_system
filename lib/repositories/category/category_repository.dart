import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/category_model.dart';
import 'package:dcs_inventory_system/repositories/category/base_category_repository.dart';
import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:fpdart/fpdart.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  FutureVoid createCategory(Category category) async {
    try {
      var categoryDoc = await _firebaseFirestore
          .collection("categories")
          .where('categoryName', isEqualTo: category.categoryName.toLowerCase())
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();
      }).first;
      if (categoryDoc.isNotEmpty) {
        throw 'Category with the same name already exists!';
      }
      // ignore: void_checks
      return right(_firebaseFirestore
          .collection('categories')
          .add(category.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<Category>> getAllCategory() {
    return _firebaseFirestore
        .collection('categories')
        .orderBy('dateCreated')
        .snapshots()
        .map((snapshots) {
      return snapshots.docs.map((doc) => Category.fromSnapshot(doc)).toList();
    });
  }
}
