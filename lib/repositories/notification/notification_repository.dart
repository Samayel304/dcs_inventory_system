import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/notifcation_model.dart';
import 'package:dcs_inventory_system/repositories/notification/base_notification_repository.dart';

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
}
