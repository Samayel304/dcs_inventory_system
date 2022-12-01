import 'package:dcs_inventory_system/models/notification_model.dart';
import 'package:dcs_inventory_system/utils/type_def.dart';

abstract class BaseNotificationRepository {
  Future<void> createNotification(NotificationModel notification);
  Stream<List<NotificationModel>> getAllNotifications();
  FutureVoid readNotification(NotificationModel notificationModel);
  Future<void> seenNotification(List<NotificationModel> notifications);
}
