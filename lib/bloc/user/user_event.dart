part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class UpdateUsers extends UserEvent {
  final List<UserModel> users;
  const UpdateUsers({required this.users});
  @override
  List<Object> get props => [users];
}

class CreateUser extends UserEvent {
  final UserModel user;
  final String password;
  final BuildContext context;
  const CreateUser(this.user, this.context, this.password);
  @override
  List<Object> get props => [user, context, password];
}

class EditUser extends UserEvent {
  final UserModel user;
  final BuildContext context;
  const EditUser(this.user, this.context);
  @override
  List<Object> get props => [user, context];
}

class ChangeProfilePicture extends UserEvent {
  final UserModel user;
  final XFile image;
  final BuildContext context;

  const ChangeProfilePicture(this.user, this.context, this.image);
  @override
  List<Object> get props => [user, context, image];
}

class ChangeUserPassword extends UserEvent {
  final String uid;
  final String newPassword;
  final BuildContext context;

  const ChangeUserPassword(this.uid, this.context, this.newPassword);
  @override
  List<Object> get props => [uid, context];
}
