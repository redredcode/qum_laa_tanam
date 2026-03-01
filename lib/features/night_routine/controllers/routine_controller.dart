import 'dart:async';

import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/alarm_service.dart';
import '../services/background_service.dart';
import '../services/countdown_service.dart';
import '../services/time_calculator_service.dart';
import '../services/sleep_cycle_service.dart';
import '../services/voice_service.dart';

class RoutineController extends GetxController {

  Timer? _timer;
  final remainingTime = Duration.zero.obs;
  final remainingText = "".obs;

  final spokenFlags = <int, bool>{}.obs;
  // prevents repeated voice spam

  void checkVoiceAlert() {
    final mins = remainingTime.value.inMinutes;

    if (mins == 30 && spokenFlags[30] != true) {
      VoiceService.speak("30 minutes left until Fajr");
      spokenFlags[30] = true;
    }

    if (mins == 15 && spokenFlags[15] != true) {
      VoiceService.speak("15 minutes left until Fajr");
      spokenFlags[15] = true;
    }

    if (mins == 5 && spokenFlags[5] != true) {
      VoiceService.speak("5 minutes left until Fajr");
      spokenFlags[5] = true;
    }
  }

  void startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = CountdownService.getRemainingTime(fajrTime.value);

      remainingTime.value = remaining;
      remainingText.value = CountdownService.formatDuration(remaining);

      /// voice logic hook
      checkVoiceAlert();

      // stop if fajr reached
      if (remaining.inSeconds <= 0) {
        _timer?.cancel();
      }
    });
  }

  /// tasks
  final tasks = <TaskModel>[].obs;

  /// buffer time
  final bedExitBuffer = 5.obs;

  /// fajr time
  final fajrTime = DateTime.now().obs;

  /// calculated values
  final totalMinutes = 0.obs;
  final wakeUpTime = DateTime.now().obs;
  final sleepTimes = <DateTime>[].obs;

  // ----------------------

  void calculateRoutine() {
    // get enabled tasks only
    final enabledTasks = tasks.where((t) => t.enabled).toList();

    // extract minutes
    final taskMinutes = enabledTasks.map((t) => t.totalMinutes).toList();

    // total time
    final total = TimeCalculatorService.calculateTotalMinutes(
      taskMinutes: taskMinutes,
      bufferMinutes: bedExitBuffer.value,
    );

    totalMinutes.value = total;

    // wake up time
    final wake = TimeCalculatorService.calculateWakeUpTime(
      fajrTime: fajrTime.value,
      totalMinutes: total,
    );

    wakeUpTime.value = wake;

    // sleep times
    final sleeps = SleepCycleService.generateSleepTimes(wake);
    sleepTimes.value = sleeps;
  }

  // ----------------------

  void addTask(TaskModel task) {
    tasks.add(task);
    calculateRoutine();
  }

  void removeTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    calculateRoutine();
  }

  void toggleTask(String id) {
    final task = tasks.firstWhere((t) => t.id == id);
    task.enabled = !task.enabled;
    tasks.refresh();
    calculateRoutine();
  }

  // void checkVoiceAlert() {
  //   final mins = remainingTime.value.inMinutes;
  //
  //   if (mins == 30) {
  //     // voice: 30 minutes left
  //   }
  //   else if (mins == 15) {
  //     // voice: 15 minutes left
  //   }
  //   else if (mins == 5) {
  //     // voice: 5 minutes left
  //   }
  // }

  /// alarm
  void scheduleWakeUpAlarm() {
    AlarmService.scheduleAlarm(
      dateTime: wakeUpTime.value,
      title: "Tahajjud Routine",
      body: "Time to wake up for Tahajjud, study and Suhoor",
    );
  }

  void cancelWakeUpAlarm() {
    AlarmService.cancelAlarm();
  }

  /// Background activity
  void startNightRoutineSystem() {
    BackgroundService.start();
    startCountdown();
  }

  void stopNightRoutineSystem() {
    BackgroundService.stop();
    _timer?.cancel();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}