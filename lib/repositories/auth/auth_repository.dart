import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';

import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  FutureEither<auth.User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      return right(user);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // ignore: void_checks
      return right(_firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
