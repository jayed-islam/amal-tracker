import 'package:adhan_dart/adhan_dart.dart';
import 'package:amal_tracker/core/constants/location_data.dart';

class PrayerService {
  static const Map<String, String> prayerNamesBn = {
    'fajr': 'ফজর',
    'zuhr': 'যোহর',
    'dhuhr': 'যোহর',
    'asr': 'আসর',
    'maghrib': 'মাগরিব',
    'isha': 'এশা',
  };

  /// Calculates today's prayer start times for given coordinates (or district name) using Karachi calculation method (Hanafi).
  static Map<String, DateTime>? getTodayPrayerTimes(
    double? lat,
    double? lng, {
    String? district,
  }) {
    double? finalLat = lat;
    double? finalLng = lng;

    if ((finalLat == null || finalLng == null) &&
        district != null &&
        district.trim().isNotEmpty) {
      final coords = LocationData.getCoordinates(district);
      finalLat = coords['latitude'];
      finalLng = coords['longitude'];
    }

    if (finalLat == null || finalLng == null) return null;
    try {
      final coordinates = Coordinates(finalLat, finalLng);
      final params = CalculationMethodParameters.karachi();
      params.madhab = Madhab.hanafi;

      final prayerTimes = PrayerTimes(
        coordinates: coordinates,
        date: DateTime.now(),
        calculationParameters: params,
      );

      return {
        'fajr': prayerTimes.fajr!,
        'zuhr': prayerTimes.dhuhr!,
        'dhuhr': prayerTimes.dhuhr!,
        'asr': prayerTimes.asr!,
        'maghrib': prayerTimes.maghrib!,
        'isha': prayerTimes.isha!,
      };
    } catch (_) {
      return null;
    }
  }

  /// Performs client-side pre-check for unstarted Fard prayers.
  /// Returns Bengali error message if any selected Fard prayer's start time hasn't arrived yet.
  static String? checkUnstartedPrayer({
    required List<Map<String, dynamic>> items,
    required double? latitude,
    required double? longitude,
    String? district,
  }) {
    final times =
        getTodayPrayerTimes(latitude, longitude, district: district);
    if (times == null) return null; // If location missing, let backend handle LOCATION_REQUIRED

    final now = DateTime.now();

    for (final item in items) {
      final isFard = item['isFard'] == true;
      final isPrayer = item['isPrayer'] == true;
      final isSelected = item['isSelected'] == true;
      final key = (item['key'] as String? ?? '').toLowerCase();

      if (isFard && isPrayer && isSelected) {
        final startTime = times[key];
        if (startTime != null && now.isBefore(startTime)) {
          final bnName = prayerNamesBn[key] ?? item['nameBn'] ?? key;
          return '$bnName-এর সময় এখনও শুরু হয়নি। অনুগ্রহ করে $bnName-এর স্ট্যাটাস তুলে দিয়ে বাকি আমলগুলো সেভ করুন।';
        }
      }
    }

    return null;
  }
}
