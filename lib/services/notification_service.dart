import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<String> getDeviceID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'IOS Device ID';
    }
    return 'dev-id';
  }

  Future<void> initLocalNotification() async {
    var androidInitializingSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosIntializingSetting = const DarwinInitializationSettings();
    var intialiazingSetting = InitializationSettings(
        android: androidInitializingSetting, iOS: iosIntializingSetting);
    await _flutterNotificationPlugin.initialize(intialiazingSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  // Commented out Firebase Messaging notification method
  // Future<void> showNotification(RemoteMessage message) async {
  //   final channel = AndroidNotificationChannel(
  //     Random.secure().nextInt(10000).toString(),
  //     'My Career Prep Toolbox',
  //     importance: Importance.max,
  //   );
  //   final androidNotificationDetails = AndroidNotificationDetails(
  //     channel.id,
  //     channel.name,
  //     channelDescription: 'My Career Prep Toolbox',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     ticker: 'Ticker',
  //   );

  //   const drawinNotificationDetails = DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //   final notificationDetail = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: drawinNotificationDetails,
  //   );

  //   await Future.delayed(Duration.zero, () {
  //     if (Platform.isAndroid) {
  //       _flutterNotificationPlugin.show(
  //         0,
  //         message.notification?.title.toString(),
  //         message.notification?.body.toString(),
  //         notificationDetail,
  //       );
  //     }
  //   });
  // }

  Future<void> requestNotificationPermission() async {
    // Commented out Firebase Messaging permission request
    // NotificationSettings settings = await messaging.requestPermission(
    //     alert: true,
    //     announcement: true,
    //     badge: true,
    //     carPlay: true,
    //     criticalAlert: true,
    //     sound: true,
    //     provisional: true);
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   debugPrint('Permission Granted');
    // } else if (settings.authorizationStatus ==
    //     AuthorizationStatus.provisional) {
    //   debugPrint('Permission Granted provisional');
    // } else {
    //   debugPrint('Permission Denied');
    // }

    // await messaging.setForegroundNotificationPresentationOptions(
    //   alert: true, // Required to display a heads up notification
    //   badge: true,
    //   sound: true,
    // );
    
    debugPrint('Firebase Messaging permission request commented out');
  }

  Future<String> getToken() async {
    // Commented out Firebase Messaging token
    // String? token = await messaging.getToken();
    // print('FCM Token: $token');
    // return token ?? "token";
    
    // Return a dummy token
    return "dummy_fcm_token_${DateTime.now().millisecondsSinceEpoch}";
  }

  Stream<void> firebaseNotification() async* {
    // Commented out Firebase Messaging stream
    // await for (final message in FirebaseMessaging.onMessage) {
    //   if (message.notification != null) {
    //     await showNotification(message);
    //   }
    //   yield null; // Just signaling the event
    // }
    
    // Return an empty stream
    yield* Stream.empty();
  }
}
