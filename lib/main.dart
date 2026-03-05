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

  print('My Prayer Times');
  final myCoordinates = Coordinates(22.327984364091726, 91.83045112487231); // Replace with your own location lat, lng.
  final params = CalculationMethod.karachi.getParameters();
  params.madhab = Madhab.shafi;
  final prayerTimes = PrayerTimes.today(myCoordinates, params);

  print("---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
  print(DateFormat.jm().format(prayerTimes.fajr));
  print(DateFormat.jm().format(prayerTimes.sunrise));
  print(DateFormat.jm().format(prayerTimes.dhuhr));
  print(DateFormat.jm().format(prayerTimes.asr));
  print(DateFormat.jm().format(prayerTimes.maghrib));
  print(DateFormat.jm().format(prayerTimes.isha));
  print('---');

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



