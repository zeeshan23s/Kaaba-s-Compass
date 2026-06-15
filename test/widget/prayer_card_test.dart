import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qibla_finder/features/prayer_times/widgets/prayer_card.dart';
import 'package:qibla_finder/shared/models/prayer_model.dart';

Widget _wrap(PrayerModel prayer) {
  return MaterialApp(
    home: Scaffold(body: PrayerCard(prayer: prayer)),
  );
}

PrayerModel _fajr({bool isNext = false}) => PrayerModel(
      nameEn: 'Fajr',
      nameAr: 'الفجر',
      time: DateTime(2024, 1, 1, 5, 30),
      icon: Icons.wb_twilight,
      isNext: isNext,
    );

void main() {
  group('PrayerCard', () {
    testWidgets('shows English and Arabic prayer names', (tester) async {
      await tester.pumpWidget(_wrap(_fajr()));
      expect(find.text('Fajr'), findsOneWidget);
      expect(find.text('الفجر'), findsOneWidget);
    });

    testWidgets('shows formatted prayer time', (tester) async {
      await tester.pumpWidget(_wrap(_fajr()));
      expect(find.text('5:30 AM'), findsOneWidget);
    });

    testWidgets('does not show NEXT badge when isNext is false', (tester) async {
      await tester.pumpWidget(_wrap(_fajr(isNext: false)));
      expect(find.text('NEXT'), findsNothing);
    });

    testWidgets('shows NEXT badge when isNext is true', (tester) async {
      await tester.pumpWidget(_wrap(_fajr(isNext: true)));
      expect(find.text('NEXT'), findsOneWidget);
    });

    testWidgets('renders without overflow', (tester) async {
      await tester.pumpWidget(_wrap(_fajr()));
      expect(tester.takeException(), isNull);
    });
  });
}
