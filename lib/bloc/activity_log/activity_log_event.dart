part of 'activity_log_bloc.dart';

abstract class ActivityLogEvent extends Equatable {
  const ActivityLogEvent();

  @override
  List<Object> get props => [];
}

class LoadActivityLogs extends ActivityLogEvent {}

class UpdateActivityLogs extends ActivityLogEvent {
  final List<ActivityLog> activityLogs;
  const UpdateActivityLogs({required this.activityLogs});
  @override
  List<Object> get props => [activityLogs];
}

class AddActivityLog extends ActivityLogEvent {
  final ActivityLog activityLog;
  const AddActivityLog({required this.activityLog});
  @override
  List<Object> get props => [activityLog];
}

class ExportActivityLog extends ActivityLogEvent {
  final BuildContext context;
  const ExportActivityLog(this.context);
  @override
  List<Object> get props => [context];
}
