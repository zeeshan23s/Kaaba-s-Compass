import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_finder/shared/models/prayer_model.dart';

PrayerModel _model(int hour, int minute) => PrayerModel(
      nameEn: 'Fajr',
      nameAr: 'الفجر',
      time: DateTime(2024, 1, 1, hour, minute),
      icon: Icons.wb_twilight,
      isNext: false,
    );

void main() {
  group('PrayerModel.formattedTime', () {
    test('midnight is 12:00 AM', () {
      expect(_model(0, 0).formattedTime, '12:00 AM');
    });

    test('noon is 12:00 PM', () {
      expect(_model(12, 0).formattedTime, '12:00 PM');
    });

    test('6:30 AM formats correctly', () {
      expect(_model(6, 30).formattedTime, '6:30 AM');
    });

    test('13:05 is 1:05 PM', () {
      expect(_model(13, 5).formattedTime, '1:05 PM');
    });

    test('18:45 is 6:45 PM', () {
      expect(_model(18, 45).formattedTime, '6:45 PM');
    });

    test('single-digit minutes are zero-padded', () {
      expect(_model(5, 3).formattedTime, '5:03 AM');
    });
  });

  group('PrayerModel.copyWith', () {
    final original = PrayerModel(
      nameEn: 'Fajr',
      nameAr: 'الفجر',
      time: DateTime(2024, 1, 1, 5, 0),
      icon: Icons.wb_twilight,
      isNext: false,
    );

    test('updates isNext', () {
      final copy = original.copyWith(isNext: true);
      expect(copy.isNext, true);
      expect(copy.nameEn, 'Fajr');
    });

    test('updates nameEn', () {
      final copy = original.copyWith(nameEn: 'Dhuhr');
      expect(copy.nameEn, 'Dhuhr');
      expect(copy.isNext, false);
    });

    test('preserves all fields when no args given', () {
      final copy = original.copyWith();
      expect(copy.nameEn, original.nameEn);
      expect(copy.nameAr, original.nameAr);
      expect(copy.isNext, original.isNext);
    });
  });
}
