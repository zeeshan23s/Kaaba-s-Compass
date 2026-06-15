class HijriDate {
  final int year;
  final int month;
  final int day;

  const HijriDate({required this.year, required this.month, required this.day});

  static HijriDate fromGregorian(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;

    int yy = y;
    int mm = m;
    if (mm <= 2) {
      yy--;
      mm += 12;
    }
    final a = yy ~/ 100;
    final b = 2 - a + a ~/ 4;
    final jd = (365.25 * (yy + 4716)).floor() +
        (30.6001 * (mm + 1)).floor() +
        d +
        b -
        1524;

    int l = jd - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    final j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    final hMonth = (24 * l) ~/ 709;
    final hDay = l - (709 * hMonth) ~/ 24;
    final hYear = 30 * n + j - 30;

    return HijriDate(year: hYear, month: hMonth, day: hDay);
  }

  static HijriDate now() => fromGregorian(DateTime.now());

  String get longMonthName => _monthNames[month - 1];

  static const List<String> _monthNames = [
    'Muharram',
    'Safar',
    "Rabi' al-Awwal",
    "Rabi' al-Thani",
    'Jumada al-Awwal',
    'Jumada al-Thani',
    'Rajab',
    "Sha'ban",
    'Ramadan',
    'Shawwal',
    "Dhu al-Qi'dah",
    'Dhu al-Hijjah',
  ];
}
