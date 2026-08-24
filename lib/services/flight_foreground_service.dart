import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:plane_alarm/services/flight_foreground_task_handler.dart';
import 'package:plane_alarm/variables/global_variables.dart';

class FlightForegroundService {
  const FlightForegroundService();

  Future<void> initialize() async {
    final notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();

    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'flight_tracking_foreground',
        channelName: 'Flight Tracking',
        channelDescription:
            'Allow Plane Alarm to track flight in the background',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(
          globalRefreshForegroundServiceMiliseconds,
        ),
        allowWifiLock: true,
      ),
    );
  }

  Future<void> start({
    required String callsign,
    required DateTime stopAt,
  }) async {
    final cleanCallsign = callsign.trim().toUpperCase();

    if (cleanCallsign.isEmpty) {
      return;
    }

    await FlutterForegroundTask.saveData(key: 'callsign', value: cleanCallsign);

    await FlutterForegroundTask.saveData(
      key: 'stopAtMillis',
      value: stopAt.millisecondsSinceEpoch,
    );

    final isRunning = await FlutterForegroundTask.isRunningService;

    if (isRunning) {
      await FlutterForegroundTask.restartService();
      return;
    }

    await FlutterForegroundTask.startService(
      serviceId: 710,
      serviceTypes: const [ForegroundServiceTypes.specialUse],
      notificationTitle: 'Tracking $cleanCallsign',
      notificationText: 'Plane Alarm is tracking this flight',
      notificationButtons: const [
        NotificationButton(id: 'stop_service', text: 'Stop'),
      ],
      callback: flightForegroundStartCallback,
    );
  }

  Future<void> stop() {
    return FlutterForegroundTask.stopService();
  }
}
