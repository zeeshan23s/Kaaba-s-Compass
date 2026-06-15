class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Qibla Finder';
  static const String appTagline = 'Your direction to Makkah';
  static const String appVersion = '1.0.0';

  // Navigation
  static const String navCompass = 'Compass';
  static const String navPrayerTimes = 'Prayer Times';
  static const String navTasbih = 'Tasbih';
  static const String navSettings = 'Settings';

  // Drawer
  static const String drawerHome = 'Home';
  static const String drawerPrayerTimes = 'Prayer Times';
  static const String drawerTasbih = 'Tasbih Counter';
  static const String drawerMosqueFinder = 'Mosque Finder';
  static const String drawerSettings = 'Settings';
  static const String drawerRateUs = 'Rate Us';
  static const String drawerHowToUse = 'How To Use';

  // Compass Screen
  static const String compassTitle = 'Qibla Finder';
  static const String headingLabel = 'Heading';
  static const String qiblaLabel = 'Qibla';
  static const String nextPrayer = 'NEXT PRAYER';
  static const String compassNotAvailable = 'Compass not available on this device';
  static const String loadingLocation = 'Getting your location...';

  // Prayer Times
  static const String prayerTimesTitle = 'Prayer Times';
  static const String nextBadge = 'NEXT';
  static const String calculationMethod = 'Calculation Method';

  // Prayer Names English
  static const String fajrEn = 'Fajr';
  static const String dhuhrEn = 'Dhuhr';
  static const String asrEn = 'Asr';
  static const String maghribEn = 'Maghrib';
  static const String ishaEn = 'Isha';

  // Prayer Names Arabic
  static const String fajrAr = 'الفجر';
  static const String dhuhrAr = 'الظهر';
  static const String asrAr = 'العصر';
  static const String maghribAr = 'المغرب';
  static const String ishaAr = 'العشاء';

  // Tasbih Screen
  static const String tasbihTitle = 'Tasbih';
  static const String totalLabel = 'Total';
  static const String subhanAllah = 'SubhanAllah';
  static const String alhamdulillah = 'Alhamdulillah';
  static const String allahuAkbar = 'Allahu Akbar';
  static const String astaghfirullah = 'Astaghfirullah';
  static const String custom = 'Custom';

  // Settings Screen
  static const String settingsTitle = 'Settings';
  static const String appearance = 'APPEARANCE';
  static const String themeLabel = 'Theme';
  static const String systemTheme = 'System';
  static const String lightTheme = 'Light';
  static const String darkTheme = 'Dark';
  static const String prayerTimesSection = 'PRAYER TIMES';
  static const String calcMethodLabel = 'Calculation Method';
  static const String notificationsLabel = 'Prayer Notifications';
  static const String compassSection = 'COMPASS';
  static const String calibrationTip =
      'Move your phone in a figure-8 motion to improve compass accuracy';
  static const String aboutSection = 'ABOUT';
  static const String appVersionLabel = 'App Version';
  static const String rateUsLabel = 'Rate Us';
  static const String shareAppLabel = 'Share App';
  static const String shareAppText =
      'Check out Qibla Finder — the best app for Muslims to find the Qibla direction and prayer times! Download now.';

  // Calculation Methods
  static const String calcMwl = 'MWL';
  static const String calcIsna = 'ISNA';
  static const String calcEgypt = 'Egypt';
  static const String calcMakkah = 'Makkah';
  static const String calcKarachi = 'Karachi';

  // Permission
  static const String locationNeededTitle = 'Location Access Needed';
  static const String locationNeededBody =
      'Qibla Finder needs your location to calculate the Qibla direction and accurate prayer times for your city.';
  static const String openSettings = 'Open Settings';

  // Mosque Finder
  static const String mosqueFinderTitle = 'Mosque Finder';
  static const String findNearestMosques = 'Find Nearest Mosques';
  static const String mosqueFinderDesc =
      'Find mosques near your current location using Google Maps.';
  static const String mosqueFinderInfo =
      'Tapping the button will open Google Maps and show mosques near your current location.';
  static const String yourLocation = 'Your Location';

  // How To Use
  static const String howToUseTitle = 'How To Use';
  static const String howToUseContent =
      '1. Open the Compass tab and allow location access.\n\n'
      '2. The green needle points toward the Qibla (Kaaba in Makkah).\n\n'
      '3. Rotate your phone until the green needle points straight up — that is the direction of prayer.\n\n'
      '4. For best accuracy, calibrate your compass by moving the phone in a figure-8 pattern.\n\n'
      '5. Check Prayer Times tab for daily prayer schedules.\n\n'
      '6. Use Tasbih counter for dhikr after prayers.';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorLocation =
      'Unable to get your location. Please check your GPS and internet connection.';

  // Time
  static const String inLabel = 'in';
  static const String hoursShort = 'h';
  static const String minutesShort = 'm';

  // Hijri months
  static const List<String> hijriMonths = [
    'Muharram', 'Safar', 'Rabi\' al-Awwal', 'Rabi\' al-Thani',
    'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', 'Sha\'ban',
    'Ramadan', 'Shawwal', 'Dhu al-Qi\'dah', 'Dhu al-Hijjah',
  ];
}
