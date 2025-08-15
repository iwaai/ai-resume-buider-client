import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:second_shot/data/repos/auth_repo.dart';
import 'package:second_shot/data/repos/notifications_repo.dart';
import 'package:second_shot/models/notification_model.dart';
import 'package:second_shot/services/notification_service.dart';
import 'package:second_shot/utils/constants/result.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationService _notificationService = NotificationService();
  final AuthRepo _authRepo = AuthRepo();
  final NotificationsRepo _notificationsRepo = NotificationsRepo();
  String deviceId = '';
  String fcmToken = '';

  NotificationsBloc() : super(NotificationsState.idle()) {
    on<DeleteNotification>(
        (event, emit) => _onDeleteNotifications(event, emit));
    on<MarkAllAsRead>((event, emit) => _markAllAsRead(event, emit));
    on<OnInit>((event, emit) => _onInit(event, emit));
    on<OnLogout>((event, emit) => _onLogout(event, emit));
    on<GetAllNotifications>((event, emit) => _getAllNotifications(event, emit));
    on<GetToggleNotification>(
        (event, emit) => _getToggleNotifcation(event, emit));
    on<ToggleNotification>((event, emit) => _toggleNotification(event, emit));
  }

  void _getAllNotifications(GetAllNotifications event, Emitter emit) async {
    emit(state.copyWith(isLoading: state.notifications.isEmpty));
    await _notificationsRepo.getNotifications(
        onSuccess: (List<NotificationModel> data) {
      emit(
        state.copyWith(
            notifications: data,
            hasUnread: true,
            result: Result.successful('Fetched Successfully', event),
            isLoading: false),
      );
    }, onFailure: (msg) {
      emit(state.copyWith(result: Result.error(msg, event), isLoading: false));
    });
  }

  void _onDeleteNotifications(DeleteNotification event, Emitter emit) async {
    List<NotificationModel> notifications = [...state.notifications];

    ///Hold the notification, incase error occurs, add it back to the list
    final notification = notifications[event.index];
    notifications.removeAt(event.index);
    emit(state.copyWith(notifications: notifications));
    await _notificationsRepo.deleteNotification(
        notificationId: notification.id,
        onSuccess: (String msg) {
          emit(state.copyWith(result: Result.successful(msg, event)));
        },
        onFailure: (String msg) {
          notifications.add(notification);
          emit(state.copyWith(
              notifications: notifications, result: Result.error(msg, event)));
        });
  }

  void _markAllAsRead(MarkAllAsRead event, Emitter emit) async {
    List<NotificationModel> notifications = [...state.notifications];
    List<NotificationModel> notificationsTemp = [...state.notifications];
    for (var notification in notifications) {
      notification.isRead = true;
    }
    emit(state.copyWith(
      hasUnread: false,
      notifications: notifications,
    ));
    await _notificationsRepo.markNotificationsAsRead(onSuccess: (String msg) {
      emit(state.copyWith(result: Result.successful(msg, event)));
    }, onFailure: (String msg) {
      emit(state.copyWith(
          hasUnread: true,
          notifications: notificationsTemp,
          result: Result.error(msg, event)));
    });
  }

  void _onInit(OnInit event, Emitter emit) async {
    await _notificationService.requestNotificationPermission();
    deviceId = await _notificationService.getDeviceID();
    fcmToken = await _notificationService.getToken();
    await _authRepo.updateFCM(
        fcm: fcmToken,
        deviceID: deviceId,
        onSuccess: (String msg) {
          print(msg);
        },
        onFailure: (String msg) {
          print(msg);
        });
    await _notificationService.initLocalNotification().then((value) async {
      // _notificationService.firebaseNotification().listen((hasUnread) {
      //   print(emit.isDone);
      //   if (!emit.isDone) {
      //     emit(state.copyWith(hasUnread: true));
      //   }
      // });
      await emit.forEach(
        _notificationService.firebaseNotification(),
        onData: (_) => state.copyWith(hasUnread: true),
      );
    });

    emit(state.copyWith(hasUnread: true));
  }

  void _onLogout(OnLogout event, Emitter emit) {
    deviceId = '';
    fcmToken = '';
    emit(state.copyWith(notifications: [], hasUnread: false));
  }

  void _getToggleNotifcation(GetToggleNotification event, Emitter emit) async {
    emit(state.copyWith(isLoading: true, result: Result.idle()));

    await _notificationsRepo.getToggleNotification(onSuccess: (res) {
      log("========> ${res['notification_enabled']}");

      emit(state.copyWith(
          isLoading: true,
          result: Result.successful('', event),
          toggleNotification: res['notification_enabled']));
    }, onFailure: (e) {
      emit(
        state.copyWith(isLoading: false, result: Result.error(e, event)),
      );
    });
  }

  void _toggleNotification(ToggleNotification event, Emitter emit) async {
    emit(state.copyWith(
        result: Result.idle(), toggleNotification: !state.toggleNotification));
    await _notificationsRepo.toggleNotifcation(onSuccess: (messsage) {
      emit(
        state.copyWith(result: Result.successful(messsage, event)),
      );
    }, onFailure: (e) {
      emit(
        state.copyWith(
            result: Result.successful(e, event),
            toggleNotification: !state.toggleNotification),
      );
    });
  }
}
