import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/hijri_utils.dart';
import '../../../core/utils/qibla_utils.dart';
import '../../../shared/widgets/permission_denied_widget.dart';
import '../providers/compass_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/accuracy_ring.dart';
import '../widgets/compass_widget.dart';
import '../widgets/next_prayer_banner.dart';

class CompassScreen extends ConsumerStatefulWidget {
  const CompassScreen({super.key});

  @override
  ConsumerState<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends ConsumerState<CompassScreen> {
  DateTime? _lastHaptic;

  void _maybeHaptic(double heading, double qibla) {
    final diff = (heading - qibla).abs();
    final aligned = diff < 2 || diff > 358;
    if (!aligned) return;
    final now = DateTime.now();
    if (_lastHaptic == null ||
        now.difference(_lastHaptic!) > const Duration(seconds: 3)) {
      _lastHaptic = now;
      HapticFeedback.mediumImpact();
    }
  }

  String _hijriDate() {
    final h = HijriDate.now();
    return '${h.day} ${h.longMonthName} ${h.year} AH';
  }

  String _gregorianDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  AccuracyLevel _accuracyFromEvent(CompassEvent event) {
    final acc = event.accuracy;
    if (acc == null) return AccuracyLevel.low;
    if (acc < 15) return AccuracyLevel.high;
    if (acc < 30) return AccuracyLevel.medium;
    return AccuracyLevel.low;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider);
    final compassAsync = ref.watch(compassProvider);
    final locationAsync = ref.watch(locationProvider);
    final qiblaAsync = ref.watch(qiblaDirectionProvider);
    final cityAsync = ref.watch(cityNameProvider);

    final goldColor = isDark ? AppColors.goldPrimary : AppColors.goldDark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          AppStrings.compassTitle,
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              final next = themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              ref.read(themeProvider.notifier).setTheme(next);
            },
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round,
              color: goldColor,
            ),
          ),
        ],
      ),
      body: locationAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: goldColor,
          ),
        ),
        error: (e, _) => const PermissionDeniedWidget(),
        data: (_) {
          return compassAsync.when(
            loading: () => Center(
              child: CircularProgressIndicator(color: goldColor),
            ),
            error: (e, _) => Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.explore_off, size: 48, color: goldColor),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.compassNotAvailable,
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (event) {
              final heading = event.heading ?? 0.0;
              final qibla = qiblaAsync.valueOrNull ?? 0.0;
              _maybeHaptic(heading, qibla);
              final accuracy = _accuracyFromEvent(event);

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // City + Hijri date block
                    cityAsync.when(
                      loading: () => const SizedBox(height: 48),
                      error: (_, __) => const SizedBox(height: 48),
                      data: (city) => Column(
                        children: [
                          Text(city, style: theme.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(_hijriDate(), style: theme.textTheme.bodySmall),
                          const SizedBox(height: 2),
                          Text(
                            _gregorianDate(),
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Next prayer banner
                    const NextPrayerBanner(),
                    const SizedBox(height: 24),
                    // Compass widget
                    CompassWidget(
                      heading: heading,
                      qiblaDirection: qibla,
                      accuracy: accuracy,
                    ),
                    const SizedBox(height: 24),
                    // Stats row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  AppStrings.headingLabel,
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  QiblaUtils.formatDegrees(heading),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 36,
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  AppStrings.qiblaLabel,
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                qiblaAsync.when(
                                  loading: () => const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  error: (_, __) => Text(
                                    '--',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  data: (q) => Text(
                                    '${q.toStringAsFixed(0)}°',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.qiblaNeedle
                                          : AppColors.qiblaLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

}
