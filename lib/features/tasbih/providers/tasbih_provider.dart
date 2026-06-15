import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/tasbih_model.dart';
import '../../../core/constants/app_strings.dart';

const _dhikrTargets = {
  AppStrings.subhanAllah: 33,
  AppStrings.alhamdulillah: 33,
  AppStrings.allahuAkbar: 33,
  AppStrings.astaghfirullah: 100,
  AppStrings.custom: 33,
};

class TasbihNotifier extends StateNotifier<TasbihState> {
  TasbihNotifier()
      : super(const TasbihState(
          count: 0,
          total: 0,
          target: 33,
          dhikrName: AppStrings.subhanAllah,
        )) {
    _load();
  }

  static const String _countKey = 'tasbih_count';
  static const String _totalKey = 'tasbih_total';
  static const String _dhikrKey = 'tasbih_dhikr';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_countKey) ?? 0;
    final total = prefs.getInt(_totalKey) ?? 0;
    final dhikr = prefs.getString(_dhikrKey) ?? AppStrings.subhanAllah;
    final target = _dhikrTargets[dhikr] ?? 33;
    state = TasbihState(count: count, total: total, target: target, dhikrName: dhikr);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_countKey, state.count);
    await prefs.setInt(_totalKey, state.total);
    await prefs.setString(_dhikrKey, state.dhikrName);
  }

  void increment() {
    final newCount = state.count + 1;
    if (newCount >= state.target) {
      state = state.copyWith(count: 0, total: state.total + newCount);
    } else {
      state = state.copyWith(count: newCount);
    }
    _persist();
  }

  void reset() {
    state = state.copyWith(count: 0, total: 0);
    _persist();
  }

  void setDhikr(String dhikr) {
    final target = _dhikrTargets[dhikr] ?? 33;
    state = state.copyWith(dhikrName: dhikr, target: target, count: 0);
    _persist();
  }

  void setCustomTarget(int target) {
    state = state.copyWith(target: target, count: 0);
  }
}

final tasbihProvider =
    StateNotifierProvider<TasbihNotifier, TasbihState>((ref) => TasbihNotifier());
