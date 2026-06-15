import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qibla_finder/features/tasbih/providers/tasbih_provider.dart';
import 'package:qibla_finder/core/constants/app_strings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('TasbihNotifier', () {
    test('initial state has zero count and total with SubhanAllah', () {
      final notifier = TasbihNotifier();
      expect(notifier.state.count, 0);
      expect(notifier.state.total, 0);
      expect(notifier.state.target, 33);
      expect(notifier.state.dhikrName, AppStrings.subhanAllah);
    });

    test('increment increases count by 1', () async {
      final notifier = TasbihNotifier();
      await Future.delayed(Duration.zero);
      notifier.increment();
      expect(notifier.state.count, 1);
    });

    test('increment resets count and adds to total when target reached', () async {
      final notifier = TasbihNotifier();
      await Future.delayed(Duration.zero);
      for (int i = 0; i < 33; i++) {
        notifier.increment();
      }
      expect(notifier.state.count, 0);
      expect(notifier.state.total, 33);
    });

    test('multiple cycles accumulate in total', () async {
      final notifier = TasbihNotifier();
      await Future.delayed(Duration.zero);
      for (int i = 0; i < 66; i++) {
        notifier.increment();
      }
      expect(notifier.state.count, 0);
      expect(notifier.state.total, 66);
    });

    test('reset clears count and total to zero', () async {
      final notifier = TasbihNotifier();
      await Future.delayed(Duration.zero);
      notifier.increment();
      notifier.increment();
      notifier.reset();
      expect(notifier.state.count, 0);
      expect(notifier.state.total, 0);
    });

    test('setDhikr updates name and target, resets count', () async {
      final notifier = TasbihNotifier();
      await Future.delayed(Duration.zero);
      notifier.increment();
      notifier.setDhikr(AppStrings.astaghfirullah);
      expect(notifier.state.dhikrName, AppStrings.astaghfirullah);
      expect(notifier.state.target, 100);
      expect(notifier.state.count, 0);
    });

    test('setDhikr to Alhamdulillah keeps target at 33', () async {
      final notifier = TasbihNotifier();
      await Future.delayed(Duration.zero);
      notifier.setDhikr(AppStrings.alhamdulillah);
      expect(notifier.state.target, 33);
    });

    test('setCustomTarget updates target and resets count', () async {
      final notifier = TasbihNotifier();
      await Future.delayed(Duration.zero);
      notifier.increment();
      notifier.setCustomTarget(99);
      expect(notifier.state.target, 99);
      expect(notifier.state.count, 0);
    });
  });
}
