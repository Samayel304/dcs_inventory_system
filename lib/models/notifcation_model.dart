import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String message;
  final String userUid;
  final DateTime dateCreated;

  const NotificationModel(
      {required this.message,
      required this.userUid,
      required this.dateCreated});
  factory NotificationModel.fromSnapshot(DocumentSnapshot snap) {
    return NotificationModel(
        message: snap['message'],
        userUid: snap['userUid'],
        dateCreated: snap['dataCreated']);
  }

  Map<String, dynamic> toDocument() {
    return {'message': message, 'userUid': userUid, 'dateCreated': dateCreated};
  }

  @override
  List<Object?> get props => [message, userUid, dateCreated];
}
