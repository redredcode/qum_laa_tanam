import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'app.dart';
import 'features/night_routine/services/alarm_service.dart';
import 'features/night_routine/services/location_service.dart';
import 'features/night_routine/services/voice_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.instance.init(); // fetch location + city name

  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'night_routine_service',
      channelName: 'Night Routine Service',
      channelDescription: 'Keeps night routine active',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
      isSticky: true,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 5000,
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
  );

  await VoiceService.init();

  await AlarmService.init();
  runApp(const QumLaTanam());
}



