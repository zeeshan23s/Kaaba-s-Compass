import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../core/utils/permission_utils.dart';
import '../../../core/utils/qibla_utils.dart';

final locationProvider = FutureProvider<Position>((ref) async {
  return PermissionUtils.getCurrentPosition();
});

final cityNameProvider = FutureProvider<String>((ref) async {
  final position = await ref.watch(locationProvider.future);
  try {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final city = placemark.locality ?? placemark.subAdministrativeArea ?? '';
      final country = placemark.country ?? '';
      if (city.isNotEmpty && country.isNotEmpty) {
        return '$city, $country';
      } else if (city.isNotEmpty) {
        return city;
      } else if (country.isNotEmpty) {
        return country;
      }
    }
  } catch (_) {}
  return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
});

final qiblaDirectionProvider = FutureProvider<double>((ref) async {
  final position = await ref.watch(locationProvider.future);
  return QiblaUtils.calculate(position.latitude, position.longitude);
});
