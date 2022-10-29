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
