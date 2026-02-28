class TimeCalculatorService {

  /// total minutes needed for all tasks + buffer
  static int calculateTotalMinutes({
    required List<int> taskMinutes,
    required int bufferMinutes,
  }) {
    int total = bufferMinutes;

    for (final m in taskMinutes) {
      total += m;
    }

    return total;
  }

  /// wake up time = fajr - totalTime
  static DateTime calculateWakeUpTime({
    required DateTime fajrTime,
    required int totalMinutes,
  }) {
    return fajrTime.subtract(Duration(minutes: totalMinutes));
  }
}