import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_finder/core/utils/qibla_utils.dart';

void main() {
  group('QiblaUtils.calculate', () {
    test('returns 0 when at Kaaba location', () {
      final result = QiblaUtils.calculate(21.4225, 39.8262);
      expect(result, closeTo(0.0, 0.001));
    });

    test('returns ~0 from directly south of Kaaba', () {
      final result = QiblaUtils.calculate(0.0, 39.8262);
      expect(result, closeTo(0.0, 0.5));
    });

    test('returns ~180 from directly north of Kaaba', () {
      final result = QiblaUtils.calculate(45.0, 39.8262);
      expect(result, closeTo(180.0, 0.5));
    });

    test('London points SE toward Makkah', () {
      final result = QiblaUtils.calculate(51.5074, -0.1278);
      expect(result, closeTo(118.8, 1.0));
    });

    test('New York points NE toward Makkah', () {
      final result = QiblaUtils.calculate(40.7128, -74.0060);
      expect(result, closeTo(58.4, 1.0));
    });

    test('Karachi points W toward Makkah', () {
      final result = QiblaUtils.calculate(24.8607, 67.0011);
      expect(result, closeTo(267.6, 1.0));
    });

    test('result is always in [0, 360)', () {
      final cases = [
        [51.5074, -0.1278],
        [40.7128, -74.0060],
        [24.8607, 67.0011],
        [-6.2088, 106.8456],
        [35.6762, 139.6503],
      ];
      for (final c in cases) {
        final r = QiblaUtils.calculate(c[0], c[1]);
        expect(r, greaterThanOrEqualTo(0.0));
        expect(r, lessThan(360.0));
      }
    });
  });

  group('QiblaUtils.compassCardinal', () {
    test('0 degrees is N', () => expect(QiblaUtils.compassCardinal(0), 'N'));
    test('90 degrees is E', () => expect(QiblaUtils.compassCardinal(90), 'E'));
    test('180 degrees is S', () => expect(QiblaUtils.compassCardinal(180), 'S'));
    test('270 degrees is W', () => expect(QiblaUtils.compassCardinal(270), 'W'));
    test('45 degrees is NE', () => expect(QiblaUtils.compassCardinal(45), 'NE'));
    test('135 degrees is SE', () => expect(QiblaUtils.compassCardinal(135), 'SE'));
    test('225 degrees is SW', () => expect(QiblaUtils.compassCardinal(225), 'SW'));
    test('315 degrees is NW', () => expect(QiblaUtils.compassCardinal(315), 'NW'));
    test('360 degrees wraps to N', () => expect(QiblaUtils.compassCardinal(360), 'N'));
    test('22.5 degrees is NNE', () => expect(QiblaUtils.compassCardinal(22.5), 'NNE'));
  });

  group('QiblaUtils.formatDegrees', () {
    test('includes cardinal direction and degree symbol', () {
      final result = QiblaUtils.formatDegrees(90.0);
      expect(result, contains('E'));
      expect(result, contains('°'));
    });

    test('formats to integer degrees', () {
      final result = QiblaUtils.formatDegrees(118.8);
      expect(result, equals('ESE 119°'));
    });

    test('north formats correctly', () {
      final result = QiblaUtils.formatDegrees(0.0);
      expect(result, equals('N 0°'));
    });
  });
}
