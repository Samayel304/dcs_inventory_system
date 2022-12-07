part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final auth.User? authUser;
  final UserModel? user;
  final bool? isInialized;

  const AuthUserChanged({required this.authUser, this.user, this.isInialized});

  @override
  List<Object?> get props => [authUser, user, isInialized];
}

class AuthLogoutRequested extends AuthEvent {}

class AddDeviceToken extends AuthEvent {
  final UserModel user;

  const AddDeviceToken(this.user);

  @override
  List<Object?> get props => [user];
}
