class SleepCycleService {
  static const int sleepCycleMinutes = 90;
  static const int fallAsleepBuffer = 15;

  /// generates possible sleep times
  static List<DateTime> generateSleepTimes(DateTime wakeUpTime) {
    List<DateTime> sleepTimes = [];

    for (int cycles = 3; cycles <= 6; cycles++) {
      final totalSleepMinutes = (cycles * sleepCycleMinutes) + fallAsleepBuffer;
      final sleepTime = wakeUpTime.subtract(Duration(minutes: totalSleepMinutes));
      sleepTimes.add(sleepTime);
    }

    return sleepTimes;
  }
}