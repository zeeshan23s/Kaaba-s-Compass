import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final compassProvider = StreamProvider<CompassEvent>((ref) {
  final events = FlutterCompass.events;
  if (events == null) {
    return Stream.error(UnsupportedError('Compass not available on this device'));
  }
  return events.timeout(
    const Duration(seconds: 12),
    onTimeout: (sink) {
      sink.addError(UnsupportedError('Compass sensor not responding'));
      sink.close();
    },
  );
});
