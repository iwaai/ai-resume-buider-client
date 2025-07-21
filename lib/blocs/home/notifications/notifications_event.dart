part of 'notifications_bloc.dart';

sealed class NotificationsEvent {}

class OnInit extends NotificationsEvent {}

class OnLogout extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final int index;
  DeleteNotification(this.index);
}

class MarkAllAsRead extends NotificationsEvent {}

class GetAllNotifications extends NotificationsEvent {}

class GetToggleNotification extends NotificationsEvent {}

class ToggleNotification extends NotificationsEvent {}
