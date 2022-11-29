import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String message;
  final List<dynamic> deviceToken;

  const NotificationModel({required this.message, required this.deviceToken});
  factory NotificationModel.fromSnapshot(DocumentSnapshot snap) {
    return NotificationModel(
        message: snap['message'], deviceToken: snap['deviceToken']);
  }

  Map<String, dynamic> toDocument() {
    return {'message': message, 'deviceToken': deviceToken};
  }

  @override
  List<Object?> get props => [message, deviceToken];
}
