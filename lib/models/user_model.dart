import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User extends Equatable {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final List<dynamic> deviceToken;

  final String role;
  final String avatarUrl;

  const User(
      {this.id,
      this.deviceToken = const [],
      required this.firstName,
      this.middleName = "",
      required this.lastName,
      required this.email,
      required this.role,
      this.avatarUrl =
          "https://firebasestorage.googleapis.com/v0/b/dcsims-2772c.appspot.com/o/default_profile.png?alt=media&token=9c83c05f-2d6b-4def-8c08-cf212738605d"});

  User copyWith(
      {String? id,
      String? firstName,
      String? middleName,
      String? lastName,
      String? email,
      String? password,
      String? role,
      String? avatarUrl,
      List<dynamic>? deviceToken}) {
    return User(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        middleName: middleName ?? this.middleName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        deviceToken: deviceToken ?? this.deviceToken);
  }

  factory User.fromSnapshot(DocumentSnapshot snap) {
    return User(
        id: snap.id,
        firstName: snap['firstName'],
        middleName: snap['middleName'],
        lastName: snap['lastName'],
        email: snap['email'],
        role: snap['role'],
        avatarUrl: snap['avatarUrl'],
        deviceToken: snap['deviceToken']);
  }

  factory User.fromActiviyLogSnapshot(Map<String, dynamic> snap) {
    return User(
        id: snap['id'],
        firstName: snap['firstName'],
        middleName: snap['middleName'],
        lastName: snap['lastName'],
        email: snap['email'],
        role: snap['role'],
        avatarUrl: snap['avatarUrl'],
        deviceToken: snap['deviceToken']);
  }

  Map<String, Object> toDocument() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'deviceToken': deviceToken
    };
  }

  Map<String, Object> toActiviyLogDocument() {
    return {
      'id': id.toString(),
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'deviceToken': deviceToken
    };
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        middleName,
        lastName,
        email,
        role,
        avatarUrl,
        deviceToken
      ];
}
