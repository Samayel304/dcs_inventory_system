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

class AddUser extends UserEvent {
  final UserModel user;
  final BuildContext context;
  const AddUser(this.user, this.context);
  @override
  List<Object> get props => [user, context];
}

class EditUser extends UserEvent {
  final UserModel user;
  final BuildContext context;
  const EditUser(this.user, this.context);
  @override
  List<Object> get props => [user, context];
}
