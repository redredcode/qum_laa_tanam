import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';

import 'location_service.dart';

class PrayerTimeService {
  PrayerTimeService._();
  static final PrayerTimeService instance = PrayerTimeService._();

  CalculationParameters get _params =>
      CalculationMethod.karachi.getParameters()..madhab = Madhab.shafi;

  Coordinates get _coords => Coordinates(
    LocationService.instance.lat,
    LocationService.instance.lng,
  );

  DateTime get fajr {
    final now = DateTime.now();
    final coords = _coords;
    final params = _params;

    final todayTimes = PrayerTimes.today(coords, params);
    final todayFajr = todayTimes.fajr;

    // adhan returns UTC — convert to local
    final todayFajrLocal = todayFajr.toLocal();

    debugPrint('── PrayerTimeService ──────────────────');
    debugPrint('Coords     : ${coords.latitude}, ${coords.longitude}');
    debugPrint('Now (local): $now');
    debugPrint('Fajr (raw) : $todayFajr');
    debugPrint('Fajr (local): $todayFajrLocal');
    debugPrint('Is after now: ${todayFajrLocal.isAfter(now)}');

    if (todayFajrLocal.isAfter(now)) {
      debugPrint('Using → today\'s Fajr: $todayFajrLocal');
      debugPrint('───────────────────────────────────────');
      return todayFajrLocal;
    }

    final tomorrowDate = DateComponents.from(now.add(const Duration(days: 1)));
    final tomorrowFajr = PrayerTimes(coords, tomorrowDate, params).fajr.toLocal();
    debugPrint('Using → tomorrow\'s Fajr: $tomorrowFajr');
    debugPrint('───────────────────────────────────────');
    return tomorrowFajr;
  }
}