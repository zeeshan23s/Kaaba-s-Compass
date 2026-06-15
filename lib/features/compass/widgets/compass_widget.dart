import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'accuracy_ring.dart';
import 'qibla_needle.dart';

class CompassWidget extends StatelessWidget {
  final double heading;
  final double qiblaDirection;
  final AccuracyLevel accuracy;

  const CompassWidget({
    super.key,
    required this.heading,
    required this.qiblaDirection,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Accuracy ring
          CustomPaint(
            size: const Size(300, 300),
            painter: AccuracyRingPainter(accuracy),
          ),
          // Compass rose (rotates with device)
          AnimatedRotation(
            turns: -heading / 360,
            duration: const Duration(milliseconds: 300),
            child: CustomPaint(
              size: const Size(280, 280),
              painter: _CompassFacePainter(isDark: isDark),
            ),
          ),
          // Qibla needle (independent rotation)
          SizedBox(
            width: 280,
            height: 280,
            child: QiblaNeedle(
              qiblaDirection: qiblaDirection,
              heading: heading,
            ),
          ),
          // Center dot
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.goldPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassFacePainter extends CustomPainter {
  final bool isDark;

  const _CompassFacePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = isDark ? AppColors.darkSurface : AppColors.lightSurface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 2, bgPaint);

    // Border circle
    final borderPaint = Paint()
      ..color = isDark ? AppColors.darkBorder : AppColors.lightBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 2, borderPaint);

    // Tick marks every 30 degrees
    final tickPaint = Paint()
      ..color = isDark ? AppColors.darkTextHint : AppColors.lightTextHint
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = i * 30 * pi / 180 - pi / 2;
      final outerPoint = Offset(
        center.dx + (radius - 8) * cos(angle),
        center.dy + (radius - 8) * sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 18) * cos(angle),
        center.dy + (radius - 18) * sin(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // North needle (pointing up, rotates with compass)
    _drawNorthNeedle(canvas, center, radius);

    // Cardinal labels
    _drawCardinalLabels(canvas, center, radius, isDark);
  }

  void _drawNorthNeedle(Canvas canvas, Offset center, double radius) {
    final needleLength = radius - 40;
    final northPaint = Paint()
      ..color = AppColors.goldPrimary
      ..style = PaintingStyle.fill;

    final northPath = Path();
    northPath.moveTo(center.dx, center.dy - needleLength);
    northPath.lineTo(center.dx - 5, center.dy);
    northPath.lineTo(center.dx + 5, center.dy);
    northPath.close();
    canvas.drawPath(northPath, northPaint);

    final southPaint = Paint()
      ..color = AppColors.darkTextHint
      ..style = PaintingStyle.fill;

    final southPath = Path();
    southPath.moveTo(center.dx, center.dy + needleLength);
    southPath.lineTo(center.dx - 5, center.dy);
    southPath.lineTo(center.dx + 5, center.dy);
    southPath.close();
    canvas.drawPath(southPath, southPaint);
  }

  void _drawCardinalLabels(
      Canvas canvas, Offset center, double radius, bool isDark) {
    const cardinals = ['N', 'E', 'S', 'W'];
    const angles = [-pi / 2, 0.0, pi / 2, pi];

    for (int i = 0; i < 4; i++) {
      final angle = angles[i];
      final isNorth = i == 0;
      final textPainter = TextPainter(
        text: TextSpan(
          text: cardinals[i],
          style: TextStyle(
            color: isNorth
                ? AppColors.goldPrimary
                : (isDark ? AppColors.darkTextHint : AppColors.lightTextHint),
            fontSize: isNorth ? 14 : 11,
            fontWeight: isNorth ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelRadius = radius - 28;
      final pos = Offset(
        center.dx + labelRadius * cos(angle) - textPainter.width / 2,
        center.dy + labelRadius * sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, pos);
    }
  }

  @override
  bool shouldRepaint(_CompassFacePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
