import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  double? _lat;
  double? _lng;
  String _cityName = '';

  double get lat => _lat ?? 22.327984364091726; // fallback: Chittagong
  double get lng => _lng ?? 91.83045112487231;
  String get cityName => _cityName;

  /// Call once in main() before runApp.
  Future<void> init() async {
    debugPrint('── LocationService.init() ─────────────');
    try {
      final permitted = await _ensurePermission();
      if (!permitted) {
        debugPrint('Permission denied — using fallback coords');
        debugPrint('───────────────────────────────────────');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      _lat = position.latitude;
      _lng = position.longitude;
      debugPrint('Position: $_lat, $_lng');

      try {
        final placemarks = await placemarkFromCoordinates(_lat!, _lng!);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          debugPrint('Placemark: ${place.locality}, ${place.subAdministrativeArea}, ${place.country}');
          _cityName = place.locality?.isNotEmpty == true
              ? place.locality!
              : place.subAdministrativeArea ?? '';
        }
        debugPrint('City: $_cityName');
      } catch (e) {
        // geocoding failed (e.g. simulator / plugin not linked)
        // city stays empty — UI will hide it gracefully
        debugPrint('Geocoding error: $e');
      }
    } catch (e) {
      debugPrint('LocationService error: $e');
      debugPrint('Using fallback coords');
    }
    debugPrint('───────────────────────────────────────');
  }

  Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    debugPrint('Permission: $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      debugPrint('Permission after request: $permission');
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}