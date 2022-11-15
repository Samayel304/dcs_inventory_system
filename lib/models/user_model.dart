import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User extends Equatable {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;

  final String role;
  final String avatarUrl;

  const User(
      {this.id,
      required this.firstName,
      this.middleName = "",
      required this.lastName,
      required this.email,
      required this.role,
      this.avatarUrl =
          "https://firebasestorage.googleapis.com/v0/b/dcsims-2772c.appspot.com/o/default_profile.png?alt=media&token=9c83c05f-2d6b-4def-8c08-cf212738605d"});

  User copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? password,
    String? role,
    String? avatarUrl,
  }) {
    return User(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        middleName: middleName ?? this.middleName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl);
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
    );
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
    );
  }

  Map<String, Object> toDocument() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
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
    };
  }

  @override
  List<Object?> get props =>
      [id, firstName, middleName, lastName, email, role, avatarUrl];
}
