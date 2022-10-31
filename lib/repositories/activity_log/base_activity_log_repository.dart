import 'package:dcs_inventory_system/models/activity_log_model.dart';

abstract class BaseActivityLogRepository {
  Stream<List<ActivityLog>> getAllActivityLogs();
  Future<void> addActivityLog(ActivityLog activityLog);
}
