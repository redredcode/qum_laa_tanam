import 'dart:async';

import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/countdown_service.dart';
import '../services/time_calculator_service.dart';
import '../services/sleep_cycle_service.dart';

class RoutineController extends GetxController {

  Timer? _timer;
  final remainingTime = Duration.zero.obs;
  final remainingText = "".obs;

  void startCountdown() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = CountdownService.getRemainingTime(fajrTime.value);

      remainingTime.value = remaining;
      remainingText.value = CountdownService.formatDuration(remaining);

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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}