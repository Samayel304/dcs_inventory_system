import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dcs_inventory_system/models/activity_log_model.dart';
import 'package:dcs_inventory_system/repositories/activity_log/base_activity_log_repository.dart';

class ActivityLogRepository extends BaseActivityLogRepository {
  final FirebaseFirestore _firebaseFirestore;

  ActivityLogRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addActivityLog(ActivityLog activityLog) async {
    await _firebaseFirestore
        .collection('activityLog')
        .add(activityLog.toDocument());
  }

  @override
  Stream<List<ActivityLog>> getAllActivityLogs() {
    return _firebaseFirestore
        .collection('activityLog')
        .orderBy('dateCreated')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ActivityLog.fromSnapshot(doc)).toList();
    });
  }
}
