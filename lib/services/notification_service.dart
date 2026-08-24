import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

Future<void> initializeNotifications() async {
  try {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/icon_airplane');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } catch (e) {
    debugPrint('Error initializing notifications: $e');
  }
}

Future<void> showProgressStatusBarNotification(int progress) async {
  PermissionStatus status = await Permission.notification.status;
  if (status.isDenied) {
    status = await Permission.notification.request();
    return status.isGranted
        ? showProgressStatusBarNotification(progress)
        : debugPrint(
          'Notification permission not granted. Cannot show notification.',
        );
  }

  if (status.isPermanentlyDenied) {
    debugPrint(
      'Notification permission not granted. Cannot show notification.',
    );
    return;
  }

  try {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'Status Bar Main Notification',
          'Status Bar Notification',
          channelDescription: 'Notifications for flight status updates',
          icon: '@drawable/icon_airplane',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
          onlyAlertOnce: true,
          showWhen: false,
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    String title;

    if (progress < 100) {
      title = 'Still flying ✈️';
    } else {
      title = 'Flight completed 🛬';
    }

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      'Progress: $progress%',
      notificationDetails,
    );
  } catch (e) {
    debugPrint('Error showing notification: $e');
  }
}

Future<void> pushNotification(String message) async {
  try {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
          'Popup Notifications',
          'Custom Text Headsup Notification',
          channelDescription: 'Notifications for delay, divert, landed',
          icon: '@drawable/icon_airplane',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'Changes in flight status',
      message,
      notificationDetails,
    );
  } catch (e) {
    debugPrint('Error pushing notification: $e');
  }
}

// Cancel all notifications, not necessarily safe, in future assign unique IDs to each notification and cancel by ID
Future<void> cancelAllAppNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
