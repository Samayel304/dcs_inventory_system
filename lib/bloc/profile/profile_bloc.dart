import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _userSubscription;

  ProfileBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const ProfileState.loading()) {
    on<UpdateProfile>(_onUpdateProfile);

    _authSubscription = _authRepository.user.listen((user) {
      if (user != null) {
        _userSubscription = _userRepository.getUser(user.uid).listen(
          (user) {
            print('refresh profile bloc');
            add(UpdateProfile(
              user: user,
            ));
          },
        );
      }
    });
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    emit(ProfileState.loaded(
        user: event.user, profileStatus: ProfileStatus.loaded));
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.close();
  }
}
