import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String? id;
  final String message;
  final String userUid;
  final DateTime dateCreated;
  final List<dynamic> readBy;
  final List<dynamic> seenBy;

  const NotificationModel(
      {this.id,
      required this.message,
      required this.userUid,
      required this.dateCreated,
      this.readBy = const [],
      this.seenBy = const []});

  NotificationModel copyWith(
      {String? id,
      String? message,
      String? userUid,
      DateTime? dateCreated,
      List<dynamic>? readBy,
      List<dynamic>? seenBy}) {
    return NotificationModel(
        id: id ?? this.id,
        message: message ?? this.message,
        userUid: userUid ?? this.userUid,
        dateCreated: dateCreated ?? this.dateCreated,
        readBy: readBy ?? this.readBy,
        seenBy: seenBy ?? this.seenBy);
  }

  factory NotificationModel.fromSnapshot(DocumentSnapshot snap) {
    return NotificationModel(
        id: snap.id,
        message: snap['message'],
        userUid: snap['userUid'],
        dateCreated: DateTime.parse(
            ((snap['dateCreated']) as Timestamp).toDate().toString()),
        readBy: snap['readBy'],
        seenBy: snap['seenBy']);
  }

  Map<String, dynamic> toDocument() {
    return {
      'message': message,
      'userUid': userUid,
      'dateCreated': dateCreated,
      'readBy': readBy,
      'seenBy': seenBy
    };
  }

  @override
  List<Object?> get props =>
      [id, message, userUid, dateCreated, readBy, seenBy];
}
