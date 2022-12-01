part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotification extends NotificationEvent {}

class UpdateNotification extends NotificationEvent {
  final List<NotificationModel> notifications;
  const UpdateNotification(this.notifications);
  @override
  List<Object> get props => [notifications];
}

class ReadNotification extends NotificationEvent {
  final NotificationModel notification;
  final BuildContext context;
  const ReadNotification(this.notification, this.context);
  @override
  List<Object> get props => [notification, context];
}

class SeenNotification extends NotificationEvent {
  final List<NotificationModel> notification;

  const SeenNotification(this.notification);
  @override
  List<Object> get props => [notification];
}
