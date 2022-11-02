import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  StreamSubscription? _userSubscription;
  UserBloc(
      {required UserRepository userRepository,
      required AuthRepository authRepository})
      : _userRepository = userRepository,
        _authRepository = authRepository,
        super(UserLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUsers>(_onUpdateUsers);
    on<AddUser>(_onAddUser);
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

  void _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      final state = this.state;
      if (state is UserLoaded) {
        await _userRepository.createUser(event.user);
        await _authRepository.signUp(
            email: event.user.email, password: event.user.email);
      }
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    super.close();
  }
}
