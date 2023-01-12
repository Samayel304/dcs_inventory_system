import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dcs_inventory_system/models/activity_log_model.dart';
import 'package:dcs_inventory_system/repositories/repository.dart';
import 'package:dcs_inventory_system/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:to_csv/to_csv.dart' as exportcsv;
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
    on<AddActivityLog>(_onAddActivityLog);
    on<ExportActivityLog>(_onExportActivityLog);
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

  void _onAddActivityLog(
      AddActivityLog event, Emitter<ActivityLogState> emit) async {
    try {
      if (state is ActivityLogLoaded) {
        await _activityLogRepository.addActivityLog(event.activityLog);
      }
    } catch (_) {}
  }

  void _onExportActivityLog(
      ExportActivityLog event, Emitter<ActivityLogState> emit) async {
    try {
      final state = this.state;
      if (state is ActivityLogLoaded) {
        List<String> header = [];

        header.add('Activity ID');
        header.add('Activity');
        header.add('Date Ordered');

        List<List<String>> listOfLists = [];
        listOfLists.add(header);
        for (var item in state.activityLogs) {
          List<String> data = [];
          data.add(item.activityLogId.toString());
          data.add(item.activity);
          data.add(item.dateCreated.formatDate());
          listOfLists.add(data);
        }

        await exportcsv.myCSV(header, listOfLists);
        showSuccessSnackBar(event.context, 'Exported Successfully');
      }
    } catch (e) {
      showErrorSnackBar(event.context, e.toString());
    }
  }

  @override
  Future<void> close() async {
    _activityLogSubscription?.cancel();
    super.close();
  }
}
