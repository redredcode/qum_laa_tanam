// import 'dart:async';
// import 'package:get/get.dart';
// import '../models/task_model.dart';
// import '../services/alarm_service.dart';
// import '../services/background_service.dart';
// import '../services/time_calculator_service.dart';
// import '../services/sleep_cycle_service.dart';
// import '../services/voice_service.dart';
//
// class RoutineController extends GetxController {
//
//   Timer? _timer;
//   final remainingTime = Duration.zero.obs;
//   final remainingText = "".obs;
//
//   final spokenFlags = <int, bool>{}.obs;
//   // prevents repeated voice spam
//
//   /// fajr time (nullable safety)
//   final fajrTime = Rxn<DateTime>();
//
//   /// tasks
//   final tasks = <TaskModel>[].obs;
//
//   /// buffer time
//   final bedExitBuffer = 5.obs;
//
//   /// calculated values
//   final totalMinutes = 0.obs;
//   final wakeUpTime = DateTime.now().obs;
//   final sleepTimes = <DateTime>[].obs;
//
//   // ---------------------- VOICE ----------------------
//
//   void resetVoiceFlags() {
//     spokenFlags.clear();
//   }
//
//   void checkVoiceAlert() {
//     final mins = remainingTime.value.inMinutes;
//
//     if (mins == 30 && spokenFlags[30] != true) {
//       VoiceService.speak("30 minutes left until Fajr");
//       spokenFlags[30] = true;
//     }
//
//     if (mins == 15 && spokenFlags[15] != true) {
//       VoiceService.speak("15 minutes left until Fajr");
//       spokenFlags[15] = true;
//     }
//
//     if (mins == 5 && spokenFlags[5] != true) {
//       VoiceService.speak("5 minutes left until Fajr");
//       spokenFlags[5] = true;
//     }
//   }
//
//   // ---------------------- COUNTDOWN ----------------------
//
//   void startCountdown() {
//     if (fajrTime.value == null) return;
//
//     _timer?.cancel();
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       final remaining = CountdownService.getRemainingTime(fajrTime.value!);
//
//       if (remaining.isNegative) {
//         remainingTime.value = Duration.zero;
//         remainingText.value = "00:00:00";
//         _timer?.cancel();
//         return;
//       }
//
//       remainingTime.value = remaining;
//       remainingText.value = CountdownService.formatDuration(remaining);
//
//       checkVoiceAlert();
//     });
//   }
//
//   // ---------------------- ROUTINE CALC ----------------------
//
//   void calculateRoutine() {
//     final enabledTasks = tasks.where((t) => t.enabled).toList();
//     final taskMinutes = enabledTasks.map((t) => t.totalMinutes).toList();
//
//     final total = TimeCalculatorService.calculateTotalMinutes(
//       taskMinutes: taskMinutes,
//       bufferMinutes: bedExitBuffer.value,
//     );
//
//     totalMinutes.value = total;
//
//     final wake = TimeCalculatorService.calculateWakeUpTime(
//       fajrTime: fajrTime.value ?? DateTime.now(),
//       totalMinutes: total,
//     );
//
//     wakeUpTime.value = wake;
//
//     final sleeps = SleepCycleService.generateSleepTimes(wake);
//     sleepTimes.value = sleeps;
//   }
//
//   // ---------------------- TASKS ----------------------
//
//   void addTask(TaskModel task) {
//     tasks.add(task);
//     calculateRoutine();
//   }
//
//   void removeTask(String id) {
//     tasks.removeWhere((t) => t.id == id);
//     calculateRoutine();
//   }
//
//   void toggleTask(String id) {
//     final index = tasks.indexWhere((t) => t.id == id);
//     if (index == -1) return;
//
//     tasks[index].enabled = !tasks[index].enabled;
//     tasks.refresh();
//     calculateRoutine();
//   }
//
//   // ---------------------- ALARM ----------------------
//
//   void scheduleWakeUpAlarm() {
//     AlarmService.scheduleAlarm(
//       dateTime: wakeUpTime.value,
//       title: "Tahajjud Routine",
//       body: "Time to wake up for Tahajjud, study and Suhoor",
//     );
//   }
//
//   void cancelWakeUpAlarm() {
//     AlarmService.cancelAlarm();
//   }
//
//   // ---------------------- SYSTEM ----------------------
//
//   void startNightRoutineSystem() {
//     resetVoiceFlags();
//     BackgroundService.start();
//     startCountdown();
//   }
//
//   void stopNightRoutineSystem() {
//     BackgroundService.stop();
//     _timer?.cancel();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }