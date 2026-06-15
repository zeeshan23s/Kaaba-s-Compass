import 'package:flutter/material.dart';

class PrayerModel {
  final String nameEn;
  final String nameAr;
  final DateTime time;
  final IconData icon;
  final bool isNext;

  const PrayerModel({
    required this.nameEn,
    required this.nameAr,
    required this.time,
    required this.icon,
    required this.isNext,
  });

  PrayerModel copyWith({
    String? nameEn,
    String? nameAr,
    DateTime? time,
    IconData? icon,
    bool? isNext,
  }) {
    return PrayerModel(
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      isNext: isNext ?? this.isNext,
    );
  }

  String get formattedTime {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }
}
