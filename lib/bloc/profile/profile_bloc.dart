import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:dcs_inventory_system/models/model.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
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
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<EditProfile>(_onEditProfile);
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) {
    _authSubscription?.cancel();
    _authSubscription = _authRepository.user.listen((authUser) {
      if (authUser != null) {
        _userSubscription?.cancel();
        _userSubscription = _userRepository.getUser(authUser.uid).listen(
          (user) {
            add(UpdateProfile(user: user));
          },
        );
      }
    });
  }

  void _onEditProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final res = await _userRepository.editUserDetails(event.user);
    res.fold((l) {}, (r) {
      showSuccessSnackBar(event.context, "Edited successfully!");
      //Navigator.of(event.context).pop();
    });
  }

  void _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileLoaded(user: event.user));
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.close();
  }
}
