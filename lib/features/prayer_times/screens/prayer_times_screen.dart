import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/hijri_utils.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/permission_denied_widget.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../widgets/prayer_card.dart';

const _methodLabels = {
  AppStrings.calcMwl: 'Muslim World League',
  AppStrings.calcIsna: 'Islamic Society of North America',
  AppStrings.calcEgypt: 'Egyptian General Authority',
  AppStrings.calcMakkah: 'Umm al-Qura, Makkah',
  AppStrings.calcKarachi: 'University of Islamic Sciences, Karachi',
};

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  String _hijriDate() {
    final h = HijriDate.now();
    return '${h.day} ${h.longMonthName} ${h.year} AH';
  }

  String _gregorianDate() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.goldPrimary : AppColors.goldDark;
    final prayerAsync = ref.watch(prayerTimesProvider);
    final settings = ref.watch(settingsProvider);

    const methods = [
      AppStrings.calcMwl,
      AppStrings.calcIsna,
      AppStrings.calcEgypt,
      AppStrings.calcMakkah,
      AppStrings.calcKarachi,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          AppStrings.prayerTimesTitle,
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: prayerAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: goldColor),
        ),
        error: (e, _) => const PermissionDeniedWidget(),
        data: (prayers) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _gregorianDate(),
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hijriDate(),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Prayer cards
              ...prayers.map((p) => PrayerCard(prayer: p)),
              const SizedBox(height: 16),
              // Calculation method dropdown
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.calculationMethod,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: settings.calculationMethod,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: goldColor,
                          ),
                          dropdownColor: isDark
                              ? AppColors.darkCard
                              : AppColors.lightCard,
                          selectedItemBuilder: (ctx) => methods
                              .map(
                                (m) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _methodLabels[m] ?? m,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              )
                              .toList(),
                          items: methods
                              .map(
                                (method) => DropdownMenuItem<String>(
                                  value: method,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _methodLabels[method] ?? method,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      Text(
                                        method,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: isDark
                                              ? AppColors.darkTextSecond
                                              : AppColors.lightTextSecond,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              ref
                                  .read(settingsProvider.notifier)
                                  .setCalculationMethod(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
