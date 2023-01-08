import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/bloc/activity_log/activity_log_bloc.dart';
import 'package:dcs_inventory_system/models/activity_log_model.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'activity_log_filter_event.dart';
part 'activity_log_filter_state.dart';

class ActivityLogFilterBloc
    extends Bloc<ActivityLogFilterEvent, ActivityLogFilterState> {
  final ActivityLogBloc _activityLogBloc;
  late StreamSubscription _activityBlocSubscription;
  ActivityLogFilterBloc({required ActivityLogBloc activityLogBloc})
      : _activityLogBloc = activityLogBloc,
        super(activityLogBloc.state is ActivityLogLoaded
            ? ActivityLogFilterLoaded(
                (activityLogBloc.state as ActivityLogLoaded).activityLogs,
                null,
                null)
            : ActivityLogFilterLoading()) {
    on<UpdateActivityLog>(_onUpdateActivityLog);
    on<SetDateRangeActivityLog>(_onSetDateRange);
    _activityBlocSubscription = _activityLogBloc.stream.listen((state) {
      if (state is ActivityLogLoaded) {
        add(UpdateActivityLog(state.activityLogs, null, null));
      }
    });
  }

  void _onUpdateActivityLog(
      UpdateActivityLog event, Emitter<ActivityLogFilterState> emit) {
    emit(ActivityLogFilterLoaded(
        event.activityLogs, event.startDate, event.endDate));
  }

  void _onSetDateRange(
      SetDateRangeActivityLog event, Emitter<ActivityLogFilterState> emit) {
    try {
      DateTime? start = event.start;
      DateTime? end = event.end;
      List<ActivityLog> activityLogs =
          (_activityLogBloc.state as ActivityLogLoaded).activityLogs;
      if (start == null || end == null) {
        add(UpdateActivityLog(activityLogs, start, end));
        showSuccessSnackBar(event.context, 'Filter Cleared!');
        Navigator.of(event.context).pop();
      } else {
        List<ActivityLog> filterActivityLog = activityLogs
            .where((activityLog) =>
                DateTime.utc(
                            activityLog.dateCreated.year,
                            activityLog.dateCreated.month,
                            activityLog.dateCreated.day)
                        .difference(
                            DateTime.utc(start.year, start.month, start.day)) >=
                    const Duration(days: 0) &&
                DateTime.utc(
                            activityLog.dateCreated.year,
                            activityLog.dateCreated.month,
                            activityLog.dateCreated.day)
                        .difference(
                            DateTime.utc(end.year, end.month, end.day)) <=
                    const Duration(days: 0))
            .toList();
        add(UpdateActivityLog(filterActivityLog, start, end));
        showSuccessSnackBar(event.context, 'Filter Added!');
        Navigator.of(event.context).pop();
      }
    } catch (e) {
      showErrorSnackBar(event.context, e.toString());
      Navigator.of(event.context).pop();
    }
  }

  @override
  Future<void> close() async {
    _activityBlocSubscription.cancel();

    super.close();
  }
}
