import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/utils/fcm_helper.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';

import '../../models/model.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/user/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<ChangePassword>(_onChangePassword);
    on<AddDeviceToken>(_onAddDeviceToken);

    _authUserSubscription = _authRepository.user.listen((authUser) {
      print('Auth user: $authUser');
      if (authUser != null) {
        _userRepository.getUser(authUser.uid).listen((user) {
          add(AuthUserChanged(
              authUser: authUser, user: user, isInialized: true));
          add(AddDeviceToken(user));
        });
      } else {
        add(AuthUserChanged(authUser: authUser, isInialized: true));
      }
    });
  }

  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.isInialized!) {
      event.authUser != null
          ? emit(AuthState.authenticated(
              authUser: event.authUser!, user: event.user!))
          : emit(const AuthState.unauthenticated());
    } else {
      await Future.delayed(const Duration(seconds: 2));
      event.authUser != null
          ? emit(AuthState.authenticated(
              authUser: event.authUser!, user: event.user!))
          : emit(const AuthState.unauthenticated());
    }
  }

  void _onAddDeviceToken(
    AddDeviceToken event,
    Emitter<AuthState> emit,
  ) async {
    String token = await FcmHelper.getToken();
    _userRepository.addDeviceToken(event.user, token);
  }

  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    unawaited(_authRepository.signOut());
  }

  void _onChangePassword(ChangePassword event, Emitter<AuthState> emit) async {
    final res = await _authRepository.changePassword(
        event.currentPassword, event.newPassword);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
    }, (r) {
      showSuccessSnackBar(event.context, 'Password changed successfully!');
    });
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
