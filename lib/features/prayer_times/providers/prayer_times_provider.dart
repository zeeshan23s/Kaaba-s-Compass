import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/compass/providers/location_provider.dart';
import '../../../features/settings/providers/settings_provider.dart';
import '../../../shared/models/prayer_model.dart';
import '../../../core/constants/app_strings.dart';

CalculationParameters _getCalculationParams(String method) {
  switch (method) {
    case 'ISNA':
      return CalculationMethod.north_america.getParameters();
    case 'Egypt':
      return CalculationMethod.egyptian.getParameters();
    case 'Makkah':
      return CalculationMethod.umm_al_qura.getParameters();
    case 'Karachi':
      return CalculationMethod.karachi.getParameters();
    case 'MWL':
    default:
      return CalculationMethod.muslim_world_league.getParameters();
  }
}

final prayerTimesProvider = FutureProvider<List<PrayerModel>>((ref) async {
  final position = await ref.watch(locationProvider.future);
  final settings = ref.watch(settingsProvider);

  final coordinates = Coordinates(position.latitude, position.longitude);
  final params = _getCalculationParams(settings.calculationMethod);
  final prayerTimes = PrayerTimes.today(coordinates, params);
  final now = DateTime.now();

  DateTime? nextPrayerTime;
  final times = [
    prayerTimes.fajr,
    prayerTimes.dhuhr,
    prayerTimes.asr,
    prayerTimes.maghrib,
    prayerTimes.isha,
  ];

  for (final t in times) {
    if (t.isAfter(now)) {
      nextPrayerTime = t;
      break;
    }
  }

  PrayerModel buildPrayer(
    String nameEn,
    String nameAr,
    DateTime time,
    IconData icon,
  ) {
    final next = nextPrayerTime;
    final isNext = next != null &&
        time.hour == next.hour &&
        time.minute == next.minute;
    return PrayerModel(
      nameEn: nameEn,
      nameAr: nameAr,
      time: time,
      icon: icon,
      isNext: isNext,
    );
  }

  return [
    buildPrayer(AppStrings.fajrEn, AppStrings.fajrAr, prayerTimes.fajr,
        Icons.brightness_3),
    buildPrayer(AppStrings.dhuhrEn, AppStrings.dhuhrAr, prayerTimes.dhuhr,
        Icons.wb_sunny),
    buildPrayer(AppStrings.asrEn, AppStrings.asrAr, prayerTimes.asr,
        Icons.wb_cloudy),
    buildPrayer(AppStrings.maghribEn, AppStrings.maghribAr,
        prayerTimes.maghrib, Icons.wb_twilight),
    buildPrayer(AppStrings.ishaEn, AppStrings.ishaAr, prayerTimes.isha,
        Icons.nights_stay),
  ];
});

class NextPrayerState {
  final String nextPrayerName;
  final Duration timeRemaining;
  final DateTime nextPrayerTime;

  const NextPrayerState({
    required this.nextPrayerName,
    required this.timeRemaining,
    required this.nextPrayerTime,
  });
}

class NextPrayerNotifier extends StateNotifier<NextPrayerState?> {
  NextPrayerNotifier(this._ref) : super(null) {
    _update();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _update());
  }

  final Ref _ref;
  Timer? _timer;

  Future<void> _update() async {
    try {
      final prayers = await _ref.read(prayerTimesProvider.future);
      final now = DateTime.now();
      for (final prayer in prayers) {
        if (prayer.time.isAfter(now)) {
          final remaining = prayer.time.difference(now);
          state = NextPrayerState(
            nextPrayerName: prayer.nameEn,
            timeRemaining: remaining,
            nextPrayerTime: prayer.time,
          );
          return;
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final nextPrayerProvider =
    StateNotifierProvider<NextPrayerNotifier, NextPrayerState?>((ref) {
  return NextPrayerNotifier(ref);
});
