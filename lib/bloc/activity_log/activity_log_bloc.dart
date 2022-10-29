import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/models/activity_log_model.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:equatable/equatable.dart';

part 'activity_log_event.dart';
part 'activity_log_state.dart';

class ActivityLogBloc extends Bloc<ActivityLogEvent, ActivityLogState> {
  final ActivityLogRepository _activityLogRepository;
  StreamSubscription? _activityLogSubscription;
  ActivityLogBloc({required ActivityLogRepository activityLogRepository})
      : _activityLogRepository = activityLogRepository,
        super(ActivityLogLoading()) {
    on<LoadActivityLogs>(_onLoadActivityLogs);
    on<UpdateActivityLogs>(_onUpdateActivityLogs);
  }
  void _onLoadActivityLogs(
      LoadActivityLogs event, Emitter<ActivityLogState> emit) {
    _activityLogSubscription?.cancel();
    _activityLogSubscription =
        _activityLogRepository.getAllActivityLogs().listen((activityLogs) {
      add(UpdateActivityLogs(activityLogs: activityLogs));
    });
  }

  void _onUpdateActivityLogs(
      UpdateActivityLogs event, Emitter<ActivityLogState> emit) {
    emit(ActivityLogLoaded(activityLogs: event.activityLogs));
  }

  @override
  Future<void> close() async {
    _activityLogSubscription?.cancel();
    super.close();
  }
}
