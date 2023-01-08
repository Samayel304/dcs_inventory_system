part of 'activity_log_filter_bloc.dart';

abstract class ActivityLogFilterEvent extends Equatable {
  const ActivityLogFilterEvent();

  @override
  List<Object?> get props => [];
}

class UpdateActivityLog extends ActivityLogFilterEvent {
  final List<ActivityLog> activityLogs;
  final DateTime? startDate;
  final DateTime? endDate;

  const UpdateActivityLog(this.activityLogs, this.startDate, this.endDate);
  @override
  List<Object?> get props => [activityLogs, startDate, endDate];
}

class SetDateRangeActivityLog extends ActivityLogFilterEvent {
  final DateTime? start;
  final DateTime? end;
  final BuildContext context;

  const SetDateRangeActivityLog(this.start, this.end, this.context);

  @override
  List<Object?> get props => [start, end, context];
}
