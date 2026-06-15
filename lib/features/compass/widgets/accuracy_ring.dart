import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum AccuracyLevel { high, medium, low }

class AccuracyRingPainter extends CustomPainter {
  final AccuracyLevel accuracy;

  const AccuracyRingPainter(this.accuracy);

  Color get _color {
    switch (accuracy) {
      case AccuracyLevel.high:
        return AppColors.accuracyHigh;
      case AccuracyLevel.medium:
        return AppColors.accuracyMed;
      case AccuracyLevel.low:
        return AppColors.accuracyLow;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(AccuracyRingPainter oldDelegate) =>
      oldDelegate.accuracy != accuracy;
}
