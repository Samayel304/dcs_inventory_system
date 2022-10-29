part of 'activity_log_bloc.dart';

abstract class ActivityLogState extends Equatable {
  const ActivityLogState();

  @override
  List<Object> get props => [];
}

class ActivityLogLoading extends ActivityLogState {}

class ActivityLogLoaded extends ActivityLogState {
  final List<ActivityLog> activityLogs;
  const ActivityLogLoaded({required this.activityLogs});

  @override
  List<Object> get props => [activityLogs];
}
