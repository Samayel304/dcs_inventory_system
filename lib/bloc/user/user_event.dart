part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class UpdateUsers extends UserEvent {
  final List<User> users;
  const UpdateUsers({required this.users});
  @override
  List<Object> get props => [users];
}

class AddUser extends UserEvent {
  final User user;
  const AddUser({required this.user});
  @override
  List<Object> get props => [user];
}
