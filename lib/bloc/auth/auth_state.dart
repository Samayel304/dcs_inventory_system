part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final auth.User? authUser;
  final UserModel? user;
  final bool isInitialized;

  const AuthState._(
      {this.status = AuthStatus.unknown,
      this.authUser,
      this.user,
      this.isInitialized = false});

  const AuthState.unknown() : this._(isInitialized: false);

  const AuthState.authenticated({
    required auth.User authUser,
    required UserModel user,
  }) : this._(
            status: AuthStatus.authenticated,
            authUser: authUser,
            user: user,
            isInitialized: true);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated, isInitialized: true);

  @override
  List<Object?> get props => [status, authUser, user, isInitialized];
}
