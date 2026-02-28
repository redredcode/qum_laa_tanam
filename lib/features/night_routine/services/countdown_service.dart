class CountdownService {

  /// returns remaining time until fajr
  static Duration getRemainingTime(DateTime fajrTime) {
    final now = DateTime.now();
    return fajrTime.difference(now);
  }

  /// formats duration nicely
  static String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    return "${hours}h ${minutes}m ${seconds}s";
  }
}