import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  StreamSubscription? _userSubscription;
  UserBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(UserLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUsers>(_onUpdateUsers);
    on<CreateUser>(_onCreateUser);
    on<EditUser>(_onEditUser);
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserState> emit) {
    _userSubscription?.cancel();
    _userSubscription = _userRepository.getAllUser().listen((users) {
      add(UpdateUsers(users: users));
    });
  }

  void _onUpdateUsers(UpdateUsers event, Emitter<UserState> emit) {
    emit(UserLoaded(users: event.users));
  }

  void _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    final state = this.state;
    if (state is UserLoaded) {
      final res = await _userRepository.createUser(event.user, event.password);
      res.fold((l) {
        showErrorSnackBar(event.context, l.message);
        Navigator.of(event.context).pop();
      }, (r) {
        showSuccessSnackBar(event.context, 'User created successfully!');
        Navigator.of(event.context).pop();
      });
    }
  }

  void _onEditUser(EditUser event, Emitter<UserState> emit) async {
    final state = this.state;
    if (state is UserLoaded) {
      final res = await _userRepository.editUserDetails(event.user);
      res.fold((l) {
        showErrorSnackBar(event.context, l.message);
      }, (r) {
        showSuccessSnackBar(event.context, 'Edited successfully!');
      });
    }
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    super.close();
  }
}
