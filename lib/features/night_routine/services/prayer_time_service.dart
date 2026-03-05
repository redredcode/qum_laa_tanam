import 'package:adhan/adhan.dart';

class PrayerTimeService {
  PrayerTimeService._();
  static final PrayerTimeService instance = PrayerTimeService._();

  // TODO: Replace with real coordinates from location service later.
  static const double _lat = 22.327984364091726;
  static const double _lng = 91.83045112487231;

  late final Coordinates _coords = Coordinates(_lat, _lng);
  late final CalculationParameters _params = CalculationMethod.karachi.getParameters()
    ..madhab = Madhab.shafi;

  DateTime get fajr {
    final now = DateTime.now();
    final todayFajr = PrayerTimes.today(_coords, _params).fajr;
    if (todayFajr.isAfter(now)) return todayFajr;

    final tomorrow = DateComponents.from(now.add(const Duration(days: 1)));
    return PrayerTimes(_coords, tomorrow, _params).fajr;
  }
}