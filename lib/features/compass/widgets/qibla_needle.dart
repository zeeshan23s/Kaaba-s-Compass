import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QiblaNeedle extends StatelessWidget {
  final double qiblaDirection;
  final double heading;

  const QiblaNeedle({
    super.key,
    required this.qiblaDirection,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final needleColor =
        isDark ? AppColors.qiblaNeedle : AppColors.qiblaLight;
    final angle = (qiblaDirection - heading) * pi / 180;

    return AnimatedRotation(
      turns: angle / (2 * pi),
      duration: const Duration(milliseconds: 300),
      child: CustomPaint(
        painter: _QiblaNeedlePainter(needleColor),
      ),
    );
  }
}

class _QiblaNeedlePainter extends CustomPainter {
  final Color color;

  const _QiblaNeedlePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final needleLength = size.height / 2 - 20;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - needleLength);
    path.lineTo(center.dx - 6, center.dy - 10);
    path.lineTo(center.dx, center.dy);
    path.lineTo(center.dx + 6, center.dy - 10);
    path.close();
    canvas.drawPath(path, paint);

    // Kaaba symbol at tip
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🕋',
        style: TextStyle(fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - needleLength - textPainter.height - 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_QiblaNeedlePainter oldDelegate) =>
      oldDelegate.color != color;
}
