part of 'activity_log_filter_bloc.dart';

abstract class ActivityLogFilterState extends Equatable {
  const ActivityLogFilterState();

  @override
  List<Object?> get props => [];
}

class ActivityLogFilterLoading extends ActivityLogFilterState {}

class ActivityLogFilterLoaded extends ActivityLogFilterState {
  final List<ActivityLog> activityLogs;
  final DateTime? startDate;
  final DateTime? endDate;

  const ActivityLogFilterLoaded(
      this.activityLogs, this.startDate, this.endDate);
  @override
  List<Object?> get props => [activityLogs, startDate, endDate];
}
