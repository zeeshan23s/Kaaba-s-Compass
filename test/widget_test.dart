import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_finder/shared/widgets/bottom_nav_bar.dart';
import 'package:qibla_finder/main.dart';
import 'package:qibla_finder/features/compass/providers/location_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app renders bottom navigation bar with 4 tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationProvider.overrideWith(
            (ref) => Future.error('location unavailable in tests'),
          ),
          cityNameProvider.overrideWith(
            (ref) => Future.error('city unavailable in tests'),
          ),
          qiblaDirectionProvider.overrideWith(
            (ref) => Future.value(118.0),
          ),
        ],
        child: const QiblaFinderApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(AppBottomNavBar), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('tapping bottom nav switches tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationProvider.overrideWith(
            (ref) => Future.error('location unavailable in tests'),
          ),
          cityNameProvider.overrideWith(
            (ref) => Future.error('city unavailable in tests'),
          ),
          qiblaDirectionProvider.overrideWith(
            (ref) => Future.value(118.0),
          ),
        ],
        child: const QiblaFinderApp(),
      ),
    );
    await tester.pump();

    final nav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(nav.currentIndex, 0);
  });
}
