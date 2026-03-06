import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'app.dart';
import 'features/night_routine/controllers/timer_controller.dart';
import 'features/night_routine/services/alarm_service.dart';
import 'features/night_routine/services/voice_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global injection
  Get.put(TimerController(), permanent: true);

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



