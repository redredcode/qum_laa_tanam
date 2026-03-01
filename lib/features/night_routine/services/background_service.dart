import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class BackgroundService {
  static void start() {
    FlutterForegroundTask.startService(
      notificationTitle: 'Night Routine Active',
      notificationText: 'Countdown running until Fajr',
    );
  }

  static void stop() {
    FlutterForegroundTask.stopService();
  }
}