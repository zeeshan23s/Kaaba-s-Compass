import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/theme_provider.dart';
import '../providers/settings_provider.dart';

const _methodLabels = {
  AppStrings.calcMwl: 'Muslim World League',
  AppStrings.calcIsna: 'Islamic Society of North America',
  AppStrings.calcEgypt: 'Egyptian General Authority',
  AppStrings.calcMakkah: 'Umm al-Qura, Makkah',
  AppStrings.calcKarachi: 'University of Islamic Sciences, Karachi',
};

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.goldPrimary : AppColors.goldDark;
    final themeMode = ref.watch(themeProvider);
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
          AppStrings.settingsTitle,
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: [
          // APPEARANCE
          const _SectionHeader(label: AppStrings.appearance),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.themeLabel, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(AppStrings.systemTheme),
                      icon: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(AppStrings.lightTheme),
                      icon: Icon(Icons.wb_sunny_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(AppStrings.darkTheme),
                      icon: Icon(Icons.nightlight_round),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (modes) {
                    ref.read(themeProvider.notifier).setTheme(modes.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return goldColor;
                      }
                      return isDark ? AppColors.darkCard : AppColors.lightCard;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return isDark
                            ? AppColors.darkBackground
                            : Colors.white;
                      }
                      return isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary;
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // PRAYER TIMES
          const _SectionHeader(label: AppStrings.prayerTimesSection),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.calcMethodLabel,
                  style: theme.textTheme.bodyMedium,
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
                      dropdownColor:
                          isDark ? AppColors.darkCard : AppColors.lightCard,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _methodLabels[method] ?? method,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    method,
                                    style: theme.textTheme.bodySmall?.copyWith(
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
          SwitchListTile(
            title: Text(
              AppStrings.notificationsLabel,
              style: theme.textTheme.bodyMedium,
            ),
            subtitle: Text(
              settings.notificationsEnabled
                  ? 'Prayer notifications are enabled'
                  : 'Prayer notifications are disabled',
              style: theme.textTheme.bodySmall,
            ),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref
                  .read(settingsProvider.notifier)
                  .setNotificationsEnabled(value);
            },
          ),
          const Divider(),

          // COMPASS
          const _SectionHeader(label: AppStrings.compassSection),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.explore_outlined, color: goldColor, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppStrings.calibrationTip,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),

          // ABOUT
          const _SectionHeader(label: AppStrings.aboutSection),
          ListTile(
            title: Text(
              AppStrings.appVersionLabel,
              style: theme.textTheme.bodyMedium,
            ),
            trailing: Text(
              AppStrings.appVersion,
              style: theme.textTheme.bodySmall,
            ),
          ),
          ListTile(
            title: Text(
              AppStrings.rateUsLabel,
              style: theme.textTheme.bodyMedium,
            ),
            leading: Icon(Icons.star_outline_rounded, color: goldColor),
            trailing: Icon(Icons.open_in_new, size: 16, color: goldColor),
            onTap: () async {
              final uri = Uri.parse(
                'https://play.google.com/store/apps/details?id=com.kaaba.qibla_finder',
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          Builder(
            builder: (ctx) => ListTile(
              title: Text(
                AppStrings.shareAppLabel,
                style: theme.textTheme.bodyMedium,
              ),
              leading: Icon(Icons.share_outlined, color: goldColor),
              onTap: () async {
                try {
                  final box = ctx.findRenderObject() as RenderBox?;
                  await Share.share(
                    AppStrings.shareAppText,
                    sharePositionOrigin: box != null
                        ? box.localToGlobal(Offset.zero) & box.size
                        : null,
                  );
                } catch (_) {}
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
