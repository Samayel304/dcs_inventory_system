import 'package:dcs_inventory_system/bloc/auth/auth_bloc.dart';
import 'package:dcs_inventory_system/utils/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/auth/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: LoginStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: LoginStatus.initial,
      ),
    );
  }

  Future<void> logInWithCredentials(BuildContext context) async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));

    final res = await _authRepository.logInWithEmailAndPassword(
      email: state.email,
      password: state.password,
    );
    res.fold(
      (l) {
        showErrorSnackBar(context, l.message);
        emit(state.copyWith(status: LoginStatus.initial));
      },
      (r) {
        emit(state.copyWith(status: LoginStatus.success));
      },
    );
  }
}
