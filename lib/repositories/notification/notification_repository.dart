import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/notification_model.dart';
import 'package:dcs_inventory_system/repositories/notification/base_notification_repository.dart';
import 'package:dcs_inventory_system/utils/failure.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class NotificationRepository extends BaseNotificationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _firebaseFirestore
          .collection('notifications')
          .add(notification.toDocument());
    } catch (e) {
      print(e);
    }
  }

  @override
  Stream<List<NotificationModel>> getAllNotifications() {
    var currentUser = FirebaseAuth.instance.currentUser;
    return _firebaseFirestore
        .collection('notifications')
        .orderBy('userUid')
        .orderBy('dateCreated')
        .where('userUid', isNotEqualTo: currentUser!.uid)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              return NotificationModel.fromSnapshot(doc);
            }).toList());
  }

  @override
  FutureVoid readNotification(NotificationModel notificationModel) async {
    try {
      var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      return (right(_firebaseFirestore
          .collection('notifications')
          .doc(notificationModel.id)
          .update({
        'readBy': FieldValue.arrayUnion([currentUserUid])
      })));
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<void> seenNotification(List<NotificationModel> notifications) async {
    try {
      var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      for (var notification in notifications) {
        await _firebaseFirestore
            .collection('notifications')
            .doc(notification.id)
            .update({
          'seenBy': FieldValue.arrayUnion([currentUserUid])
        });
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (e) {
      print(e);
    }
  }
}
