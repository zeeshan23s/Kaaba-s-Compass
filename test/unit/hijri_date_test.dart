import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_finder/core/utils/hijri_utils.dart';

void main() {
  group('HijriDate.fromGregorian', () {
    test('converts 2024-01-01 to 19 Jumada al-Thani 1445', () {
      final h = HijriDate.fromGregorian(DateTime(2024, 1, 1));
      expect(h.year, 1445);
      expect(h.month, 6);
      expect(h.day, 19);
    });

    test('returns valid field ranges for a recent date', () {
      final h = HijriDate.fromGregorian(DateTime(2025, 6, 15));
      expect(h.year, greaterThan(1440));
      expect(h.month, inInclusiveRange(1, 12));
      expect(h.day, inInclusiveRange(1, 30));
    });

    test('year increases over time', () {
      final h2024 = HijriDate.fromGregorian(DateTime(2024, 1, 1));
      final h2025 = HijriDate.fromGregorian(DateTime(2025, 1, 1));
      expect(h2025.year, greaterThanOrEqualTo(h2024.year));
    });
  });

  group('HijriDate.longMonthName', () {
    test('month 1 is Muharram', () {
      const h = HijriDate(year: 1445, month: 1, day: 1);
      expect(h.longMonthName, 'Muharram');
    });

    test('month 9 is Ramadan', () {
      const h = HijriDate(year: 1445, month: 9, day: 1);
      expect(h.longMonthName, 'Ramadan');
    });

    test('month 12 is Dhu al-Hijjah', () {
      const h = HijriDate(year: 1445, month: 12, day: 1);
      expect(h.longMonthName, 'Dhu al-Hijjah');
    });

    test('all 12 months have non-empty names', () {
      for (int m = 1; m <= 12; m++) {
        final h = HijriDate(year: 1445, month: m, day: 1);
        expect(h.longMonthName, isNotEmpty);
      }
    });
  });

  group('HijriDate.now', () {
    test('returns a valid HijriDate', () {
      final h = HijriDate.now();
      expect(h.year, greaterThan(1400));
      expect(h.month, inInclusiveRange(1, 12));
      expect(h.day, inInclusiveRange(1, 30));
    });
  });
}
