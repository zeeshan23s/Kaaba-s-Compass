import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore_rounded),
          label: AppStrings.navCompass,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time_outlined),
          activeIcon: Icon(Icons.access_time_rounded),
          label: AppStrings.navPrayerTimes,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.radio_button_unchecked),
          activeIcon: Icon(Icons.radio_button_checked_rounded),
          label: AppStrings.navTasbih,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings_rounded),
          label: AppStrings.navSettings,
        ),
      ],
    );
  }
}
