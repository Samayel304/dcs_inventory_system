import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/user_model.dart';
import 'package:dcs_inventory_system/repositories/user/base_user_repository.dart';

import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  final firebase_storage.FirebaseStorage _firebaseStorage;

  UserRepository(
      {FirebaseFirestore? firebaseFirestore,
      firebase_storage.FirebaseStorage? firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage =
            firebaseStorage ?? firebase_storage.FirebaseStorage.instance;

  @override
  FutureVoid createUser(UserModel user, String password) async {
    try {
      // ignore: void_checks
      return right(_firebaseFirestore.collection('registrations').add({
        'firstName': user.firstName,
        'middleName': user.middleName,
        'lastName': user.lastName,
        'email': user.email,
        'role': user.role,
        'avatarUrl': user.avatarUrl,
        'deviceToken': user.deviceToken,
        'password': password
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid editUserDetails(UserModel user) async {
    try {
      return right(_firebaseFirestore
          .collection('users')
          .doc(user.id)
          .update(user.toDocument()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<void> addDeviceToken(UserModel user, String deviceToken) async {
    String uidWithSameDeviceToken = '';
    List<dynamic> newDeviceToken = [];
    List<UserModel> otherUsers = await _firebaseFirestore
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: user.id)
        .get()
        .then((value) =>
            value.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());

    for (var otherUser in otherUsers) {
      if (otherUser.deviceToken.contains(deviceToken)) {
        uidWithSameDeviceToken = otherUser.id!;
        for (var token in otherUser.deviceToken) {
          if (token != deviceToken) {
            newDeviceToken.add(token);
          }
        }
      }
    }
    if (uidWithSameDeviceToken.isNotEmpty) {
      await _firebaseFirestore
          .collection('users')
          .doc(uidWithSameDeviceToken)
          .update({'deviceToken': newDeviceToken});
    }
    UserModel currentUser = await _firebaseFirestore
        .collection('users')
        .doc(user.id)
        .get()
        .then((doc) => UserModel.fromSnapshot(doc));
    bool isDeviceTokenExists = currentUser.deviceToken.contains(deviceToken);
    if (isDeviceTokenExists) return;
    await _firebaseFirestore.collection('users').doc(user.id).update({
      'deviceToken': FieldValue.arrayUnion([deviceToken])
    });
  }

  @override
  Stream<List<UserModel>> getAllUser() {
    return _firebaseFirestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    });
  }

  @override
  Stream<UserModel> getUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snap) => UserModel.fromSnapshot(snap));
  }

  @override
  FutureVoid changeUserPassword(String userUid, String password) async {
    try {
      // ignore: void_checks
      return right(_firebaseFirestore
          .collection('updatePassword')
          .add({'userUid': userUid, 'password': password}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureVoid changeProfilePicture(UserModel user, XFile image) async {
    try {
      return (right(_firebaseStorage
          .ref('image/${image.name}')
          .putFile(File(image.path))
          .then((_) async {
        String downLoadUrl = await getDownloadURL(image.name);
        _firebaseFirestore
            .collection('users')
            .doc(user.id)
            .update({'avatarUrl': downLoadUrl});
      })));
    } catch (e) {
      return (Left(Failure(e.toString())));
    }
  }

  Future<String> getDownloadURL(String imageName) async {
    String downloadURL =
        await _firebaseStorage.ref('image/$imageName').getDownloadURL();
    return downloadURL;
  }

  @override
  FutureVoid deleteUser(UserModel user) async {
    try {
      return right(
          _firebaseFirestore.collection('users').doc(user.id).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
