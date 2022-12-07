import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/models/model.dart';

import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  final AuthRepository _authRepository;
  late StreamSubscription? _notificationSubscription;

  late StreamSubscription? _authStreamSubscription;

  NotificationBloc(
      {required NotificationRepository notificationRepository,
      required AuthRepository authRepository})
      : _notificationRepository = notificationRepository,
        _authRepository = authRepository,
        super(NotificationLoading()) {
    on<LoadNotification>(_onLoadNotification);
    on<UpdateNotification>(_onUpdateNotification);
    on<ReadNotification>(_onReadNotification);
    on<SeenNotification>(_onSeenNotification);
  }

  void _onLoadNotification(
      LoadNotification event, Emitter<NotificationState> emit) {
    _authStreamSubscription = _authRepository.user.listen((user) {
      if (user != null) {
        _notificationSubscription = _notificationRepository
            .getAllNotifications(user.uid)
            .listen((notifcations) {
          add(UpdateNotification(notifcations));
        });
      }
    });
  }

  void _onUpdateNotification(
      UpdateNotification event, Emitter<NotificationState> emit) {
    emit(NotificationLoaded(event.notifications.reversed.toList()));
  }

  void _onReadNotification(
      ReadNotification event, Emitter<NotificationState> emit) async {
    var res =
        await _notificationRepository.readNotification(event.notification);
    res.fold((l) {
      showErrorSnackBar(event.context, l.message);
    }, (r) {
      GoRouter.of(event.context).go('/inventory');
    });
  }

  void _onSeenNotification(
      SeenNotification event, Emitter<NotificationState> emit) async {
    await _notificationRepository.seenNotification(event.notification);
  }

  @override
  Future<void> close() async {
    _notificationSubscription?.cancel();
    _authStreamSubscription?.cancel();
    super.close();
  }
}
