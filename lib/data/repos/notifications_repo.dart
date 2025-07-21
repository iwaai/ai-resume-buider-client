import 'dart:developer';

import 'package:second_shot/data/api_service.dart';
import 'package:second_shot/models/notification_model.dart';
import 'package:second_shot/utils/constants/app_url.dart';

class NotificationsRepo {
  final apiService = ApiService();

  Future<void> getNotifications({
    required Function(List<NotificationModel> data) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.getNotifications);
      if (response.success == true) {
        final notifications = (response.data as List)
            .map((data) => NotificationModel.fromJson(data))
            .toList();
        onSuccess(notifications);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      // onFailure(e.toString());
      rethrow;
    }
  }

  Future<void> deleteNotification({
    required String notificationId,
    required Function(String msg) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response =
          await apiService.delete(AppUrl.deleteNotifications, body: {
        'notificationId': notificationId,
      });
      if (response.success == true) {
        onSuccess(response.message ?? "");
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      // onFailure(e.toString());
      rethrow;
    }
  }

  Future<void> markNotificationsAsRead({
    required Function(String msg) onSuccess,
    required Function(String message) onFailure,
  }) async {
    try {
      final response = await apiService.get(AppUrl.markNotificationsAsRead);
      if (response.success == true) {
        onSuccess(response.message ?? "");
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      // onFailure(e.toString());
      rethrow;
    }
  }

  Future<void> getToggleNotification(
      {required Function(dynamic res) onSuccess,
      required Function(String message) onFailure}) async {
    try {
      final response =
          await apiService.get(AppUrl.getNotification, authorize: true);
      if (response.success == true) {
        // print("------ ${jsonDecode(response.data)}");
        onSuccess(response.data);
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      log("API Failure: $e");
      onFailure(e.toString());
    }
  }

  Future<void> toggleNotifcation(
      {required Function(String message) onSuccess,
      required Function(String message) onFailure}) async {
    try {
      final response =
          await apiService.post(AppUrl.toggleNotifcation, authorize: true);
      if (response.success == true) {
        onSuccess(response.message.toString());
      } else {
        onFailure(response.message.toString());
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
