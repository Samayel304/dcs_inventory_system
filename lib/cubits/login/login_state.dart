part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final AuthResultStatus? errorMessage;

  const LoginState(
      {required this.email,
      required this.password,
      required this.status,
      this.errorMessage});

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
    );
  }

  LoginState copyWith(
      {String? email,
      String? password,
      LoginStatus? status,
      AuthResultStatus? errorMessage}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [email, password, status];
}
