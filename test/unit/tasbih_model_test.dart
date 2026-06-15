import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_finder/shared/models/tasbih_model.dart';

void main() {
  group('TasbihState.progress', () {
    test('is 0.0 when count is 0', () {
      const state = TasbihState(count: 0, total: 0, target: 33, dhikrName: 'test');
      expect(state.progress, 0.0);
    });

    test('is 0.0 when target is 0', () {
      const state = TasbihState(count: 5, total: 0, target: 0, dhikrName: 'test');
      expect(state.progress, 0.0);
    });

    test('is proportional to count/target', () {
      const state = TasbihState(count: 11, total: 0, target: 33, dhikrName: 'test');
      expect(state.progress, closeTo(11 / 33, 0.0001));
    });

    test('clamps to 1.0 when count exceeds target', () {
      const state = TasbihState(count: 50, total: 0, target: 33, dhikrName: 'test');
      expect(state.progress, 1.0);
    });

    test('is exactly 1.0 when count equals target', () {
      const state = TasbihState(count: 33, total: 0, target: 33, dhikrName: 'test');
      expect(state.progress, 1.0);
    });
  });

  group('TasbihState.copyWith', () {
    const original = TasbihState(count: 5, total: 10, target: 33, dhikrName: 'SubhanAllah');

    test('updates only count', () {
      final copy = original.copyWith(count: 0);
      expect(copy.count, 0);
      expect(copy.total, 10);
      expect(copy.target, 33);
      expect(copy.dhikrName, 'SubhanAllah');
    });

    test('updates only dhikrName and target', () {
      final copy = original.copyWith(dhikrName: 'Allahu Akbar', target: 100);
      expect(copy.dhikrName, 'Allahu Akbar');
      expect(copy.target, 100);
      expect(copy.count, 5);
      expect(copy.total, 10);
    });

    test('preserves all fields when no args given', () {
      final copy = original.copyWith();
      expect(copy.count, original.count);
      expect(copy.total, original.total);
      expect(copy.target, original.target);
      expect(copy.dhikrName, original.dhikrName);
    });
  });
}
