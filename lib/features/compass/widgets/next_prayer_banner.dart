import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../prayer_times/providers/prayer_times_provider.dart';

class NextPrayerBanner extends ConsumerWidget {
  const NextPrayerBanner({super.key});

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours${AppStrings.hoursShort} $minutes${AppStrings.minutesShort}';
    }
    return '$minutes${AppStrings.minutesShort}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextPrayer = ref.watch(nextPrayerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.goldPrimary : AppColors.goldDark;

    if (nextPrayer == null) {
      return const SizedBox.shrink();
    }

    final timeStr = () {
      final h = nextPrayer.nextPrayerTime.hour;
      final m = nextPrayer.nextPrayerTime.minute;
      final period = h < 12 ? 'AM' : 'PM';
      final dh = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      return '$dh:${m.toString().padLeft(2, '0')} $period';
    }();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: goldColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: goldColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.nextPrayer,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: goldColor,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nextPrayer.nextPrayerName,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeStr,
                  style: theme.textTheme.titleLarge?.copyWith(color: goldColor),
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppStrings.inLabel} ${_formatCountdown(nextPrayer.timeRemaining)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
