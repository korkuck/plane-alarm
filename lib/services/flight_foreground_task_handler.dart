import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:plane_alarm/services/resource_cleaner_service.dart';

@pragma('vm:entry-point')
void flightForegroundStartCallback() {
  FlutterForegroundTask.setTaskHandler(FlightForegroundTaskHandler());
}

class FlightForegroundTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    debugPrint('Flight foreground service started');
  }

  @override
  void onRepeatEvent(DateTime timestamp) async {
    final stopAtMillis = await FlutterForegroundTask.getData<int>(
      key: 'stopAtMillis',
    );

    final callsign = await FlutterForegroundTask.getData<String>(
      key: 'callsign',
    );

    if (stopAtMillis == null || callsign == null) {
      return;
    }

    final nowMillis = DateTime.now().millisecondsSinceEpoch;

    if (nowMillis >= stopAtMillis) {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Plane Alarm flight tracking stopped',
        notificationText: '$callsign tracking stopped',
      );

      await stopCallsignTracking(null);
      return;
    }

    await FlutterForegroundTask.updateService(
      notificationTitle: 'Tracking $callsign',
      notificationText: 'Plane Alarm is still monitoring this flight',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    debugPrint('Flight foreground service destroyed');
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'stop_service') {
      stopCallsignTracking(null);
    }
  }
}
