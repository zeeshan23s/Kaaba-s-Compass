import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_finder/shared/models/settings_model.dart';

void main() {
  group('SettingsState.defaults', () {
    test('uses MWL as default calculation method', () {
      const s = SettingsState.defaults();
      expect(s.calculationMethod, 'MWL');
    });

    test('notifications are disabled by default', () {
      const s = SettingsState.defaults();
      expect(s.notificationsEnabled, false);
    });
  });

  group('SettingsState.copyWith', () {
    const original = SettingsState(
      calculationMethod: 'ISNA',
      notificationsEnabled: true,
    );

    test('updates calculationMethod', () {
      final copy = original.copyWith(calculationMethod: 'Egypt');
      expect(copy.calculationMethod, 'Egypt');
      expect(copy.notificationsEnabled, true);
    });

    test('updates notificationsEnabled', () {
      final copy = original.copyWith(notificationsEnabled: false);
      expect(copy.notificationsEnabled, false);
      expect(copy.calculationMethod, 'ISNA');
    });

    test('preserves all fields when no args given', () {
      final copy = original.copyWith();
      expect(copy.calculationMethod, original.calculationMethod);
      expect(copy.notificationsEnabled, original.notificationsEnabled);
    });
  });
}
