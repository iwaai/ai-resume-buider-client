part of 'notifications_bloc.dart';

class NotificationsState {
  final Result result;
  final List<NotificationModel> notifications;
  final bool isLoading;
  final bool hasUnread;
  final bool toggleNotification;

  const NotificationsState(
      {required this.result,
      this.notifications = const [],
      this.isLoading = false,
      this.hasUnread = false,
      this.toggleNotification = false});

  NotificationsState copyWith(
      {Result? result,
      List<NotificationModel>? notifications,
      bool? isLoading,
      bool? hasUnread,
      bool? toggleNotification}) {
    return NotificationsState(
        result: result ?? this.result,
        isLoading: isLoading ?? this.isLoading,
        hasUnread: hasUnread ?? this.hasUnread,
        notifications: notifications ?? this.notifications,
        toggleNotification: toggleNotification ?? this.toggleNotification);
  }

  factory NotificationsState.idle() {
    return NotificationsState(
      result: Result.idle(),
      notifications: [],
    );
  }
}
