import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/user_model.dart';
import 'package:dcs_inventory_system/repositories/user/base_user_repository.dart';
import 'package:dcs_inventory_system/utils/enums.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(User user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .set(user.toDocument());
  }

  @override
  Future<void> editUserDetails(User user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Stream<List<User>> getAllUser() {
    return _firebaseFirestore
        .collection("Users")
        .where('role', isNotEqualTo: UserRole.admin.name)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<User> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }
}
