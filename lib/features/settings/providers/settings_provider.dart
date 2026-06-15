import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/settings_model.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState.defaults()) {
    _load();
  }

  static const String _calcMethodKey = 'calc_method';
  static const String _notificationsKey = 'notifications_enabled';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final method = prefs.getString(_calcMethodKey) ?? 'MWL';
    final notifications = prefs.getBool(_notificationsKey) ?? false;
    state = SettingsState(
      calculationMethod: method,
      notificationsEnabled: notifications,
    );
  }

  Future<void> setCalculationMethod(String method) async {
    state = state.copyWith(calculationMethod: method);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calcMethodKey, method);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
