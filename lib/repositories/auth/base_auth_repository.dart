import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  FutureEither<auth.User?> signUp({
    required String email,
    required String password,
  });
  FutureVoid logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  FutureVoid changePassword(String currentPassword, String newPassword);
  Future<void> signOut();
}
