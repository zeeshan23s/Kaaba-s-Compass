import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/prayer_model.dart';

class PrayerCard extends StatelessWidget {
  final PrayerModel prayer;

  const PrayerCard({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.goldPrimary : AppColors.goldDark;

    final borderColor = prayer.isNext ? goldColor : Colors.transparent;
    final bgColor = prayer.isNext
        ? goldColor.withValues(alpha: 0.10)
        : (isDark ? AppColors.darkCard : AppColors.lightCard);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: prayer.isNext
                        ? goldColor.withValues(alpha: 0.2)
                        : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Icon(
                    prayer.icon,
                    color: prayer.isNext
                        ? goldColor
                        : (isDark ? AppColors.darkTextSecond : AppColors.lightTextSecond),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.nameAr,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 14,
                          color: prayer.isNext ? goldColor : null,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prayer.nameEn,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  prayer.formattedTime,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: prayer.isNext ? goldColor : null,
                  ),
                ),
              ],
            ),
          ),
          if (prayer.isNext)
            Positioned(
              top: 8,
              right: 24,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: goldColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NEXT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.darkBackground : Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
