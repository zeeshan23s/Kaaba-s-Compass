import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_finder/shared/widgets/bottom_nav_bar.dart';
import 'package:qibla_finder/core/constants/app_strings.dart';

Widget _wrap({required int currentIndex, ValueChanged<int>? onTap}) {
  return MaterialApp(
    home: Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap ?? (_) {},
      ),
    ),
  );
}

void main() {
  group('AppBottomNavBar', () {
    testWidgets('renders 4 navigation items', (tester) async {
      await tester.pumpWidget(_wrap(currentIndex: 0));
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text(AppStrings.navCompass), findsOneWidget);
      expect(find.text(AppStrings.navPrayerTimes), findsOneWidget);
      expect(find.text(AppStrings.navTasbih), findsOneWidget);
      expect(find.text(AppStrings.navSettings), findsOneWidget);
    });

    testWidgets('highlights the correct active tab', (tester) async {
      await tester.pumpWidget(_wrap(currentIndex: 2));
      final nav = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(nav.currentIndex, 2);
    });

    testWidgets('calls onTap with correct index when tapped', (tester) async {
      int tappedIndex = -1;
      await tester.pumpWidget(_wrap(
        currentIndex: 0,
        onTap: (i) => tappedIndex = i,
      ));
      await tester.tap(find.text(AppStrings.navPrayerTimes));
      expect(tappedIndex, 1);
    });

    testWidgets('calls onTap with settings index when settings tapped',
        (tester) async {
      int tappedIndex = -1;
      await tester.pumpWidget(_wrap(
        currentIndex: 0,
        onTap: (i) => tappedIndex = i,
      ));
      await tester.tap(find.text(AppStrings.navSettings));
      expect(tappedIndex, 3);
    });
  });
}
