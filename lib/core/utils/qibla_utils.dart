import 'dart:math';

class QiblaUtils {
  QiblaUtils._();

  static double calculate(double lat, double lng) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    final dLng = _toRad(kaabaLng - lng);
    final y = sin(dLng);
    final x = cos(_toRad(lat)) * tan(_toRad(kaabaLat)) -
        sin(_toRad(lat)) * cos(dLng);
    return (_toDeg(atan2(y, x)) + 360) % 360;
  }

  static double _toRad(double deg) => deg * pi / 180;
  static double _toDeg(double rad) => rad * 180 / pi;

  static String compassCardinal(double degrees) {
    const cardinals = [
      'N', 'NNE', 'NE', 'ENE',
      'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW',
      'W', 'WNW', 'NW', 'NNW',
    ];
    final index = ((degrees + 11.25) / 22.5).floor() % 16;
    return cardinals[index];
  }

  static String formatDegrees(double degrees) {
    final cardinal = compassCardinal(degrees);
    return '$cardinal ${degrees.toStringAsFixed(0)}°';
  }
}
