part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  const UserLoaded({required this.users});
  @override
  List<Object> get props => [users];
}
