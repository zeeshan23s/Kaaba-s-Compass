import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../features/mosque_finder/screens/mosque_finder_screen.dart';

class AppDrawer extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.goldPrimary : AppColors.goldDark;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(
                  bottom: BorderSide(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/app_logo.svg',
                  width: 240,
                  height: 80,
                  colorFilter: isDark
                      ? null
                      : const ColorFilter.mode(
                          AppColors.goldDark,
                          BlendMode.srcIn,
                        ),
                ),
              ),
            ),
            _DrawerItem(
              icon: Icons.explore_rounded,
              label: AppStrings.drawerHome,
              selected: currentIndex == 0,
              goldColor: goldColor,
              onTap: () {
                onTabChanged(0);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.access_time_rounded,
              label: AppStrings.drawerPrayerTimes,
              selected: currentIndex == 1,
              goldColor: goldColor,
              onTap: () {
                onTabChanged(1);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.radio_button_checked_rounded,
              label: AppStrings.drawerTasbih,
              selected: currentIndex == 2,
              goldColor: goldColor,
              onTap: () {
                onTabChanged(2);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.location_on_rounded,
              label: AppStrings.drawerMosqueFinder,
              selected: false,
              goldColor: goldColor,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MosqueFinderScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.settings_rounded,
              label: AppStrings.drawerSettings,
              selected: currentIndex == 3,
              goldColor: goldColor,
              onTap: () {
                onTabChanged(3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            _DrawerItem(
              icon: Icons.star_rounded,
              label: AppStrings.drawerRateUs,
              selected: false,
              goldColor: goldColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.help_outline_rounded,
              label: AppStrings.drawerHowToUse,
              selected: false,
              goldColor: goldColor,
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      AppStrings.howToUseTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                    content: SingleChildScrollView(
                      child: Text(
                        AppStrings.howToUseContent,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Got It',
                          style: TextStyle(color: goldColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color goldColor;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.goldColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: selected
            ? goldColor
            : (isDark ? AppColors.darkTextSecond : AppColors.lightTextSecond),
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: selected ? goldColor : null,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: selected,
      selectedTileColor: goldColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: onTap,
    );
  }
}
