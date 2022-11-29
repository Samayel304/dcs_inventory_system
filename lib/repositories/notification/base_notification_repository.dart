import 'package:dcs_inventory_system/models/notifcation_model.dart';

abstract class BaseNotificationRepository {
  Future<void> createNotification(NotificationModel notification);
}
