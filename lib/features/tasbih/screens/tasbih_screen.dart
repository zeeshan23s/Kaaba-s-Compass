import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/tasbih_provider.dart';

const _dhikrArabic = {
  AppStrings.subhanAllah: 'سُبْحَانَ ٱللَّهِ',
  AppStrings.alhamdulillah: 'ٱلْحَمْدُ لِلَّهِ',
  AppStrings.allahuAkbar: 'ٱللَّهُ أَكْبَرُ',
  AppStrings.astaghfirullah: 'أَسْتَغْفِرُ ٱللَّهَ',
};

class TasbihScreen extends ConsumerStatefulWidget {
  const TasbihScreen({super.key});

  @override
  ConsumerState<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends ConsumerState<TasbihScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    ref.read(tasbihProvider.notifier).increment();
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Counter'),
        content: const Text(
          'Reset both current count and total count to zero?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(tasbihProvider.notifier).reset();
              Navigator.pop(ctx);
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.goldPrimary : AppColors.goldDark;
    final state = ref.watch(tasbihProvider);
    final arabicText = _dhikrArabic[state.dhikrName] ?? '';
    final rounds = state.total ~/ state.target;

    const dhikrOptions = [
      AppStrings.subhanAllah,
      AppStrings.alhamdulillah,
      AppStrings.allahuAkbar,
      AppStrings.astaghfirullah,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          AppStrings.tasbihTitle,
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () => _showResetDialog(context),
            icon: Icon(Icons.refresh_rounded, color: goldColor),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Dhikr dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dhikrOptions.contains(state.dhikrName)
                          ? state.dhikrName
                          : dhikrOptions.first,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, color: goldColor),
                      dropdownColor:
                          isDark ? AppColors.darkCard : AppColors.lightCard,
                      style: theme.textTheme.titleMedium,
                      items: dhikrOptions
                          .map(
                            (d) => DropdownMenuItem(
                              value: d,
                              child: Text(d),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(tasbihProvider.notifier).setDhikr(value);
                        }
                      },
                    ),
                  ),
                ),
                const Spacer(),
                // Arabic text
                if (arabicText.isNotEmpty) ...[
                  Text(
                    arabicText,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: goldColor,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 32),
                ],
                // Counter ring — the main tap target
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  ),
                  child: GestureDetector(
                    onTap: _onTap,
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: CustomPaint(
                        painter: _CounterArcPainter(
                          progress: state.progress,
                          isDark: isDark,
                          goldColor: goldColor,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${state.count}',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: goldColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '/ ${state.target}',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecond
                                      : AppColors.lightTextSecond,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatBox(
                      label: 'Rounds',
                      value: '$rounds',
                      goldColor: goldColor,
                      isDark: isDark,
                      theme: theme,
                    ),
                    const SizedBox(width: 24),
                    Container(
                      width: 1,
                      height: 36,
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    const SizedBox(width: 24),
                    _StatBox(
                      label: AppStrings.totalLabel,
                      value: '${state.total}',
                      goldColor: goldColor,
                      isDark: isDark,
                      theme: theme,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Tap anywhere or the circle to count',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors.lightTextHint,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color goldColor;
  final bool isDark;
  final ThemeData theme;

  const _StatBox({
    required this.label,
    required this.value,
    required this.goldColor,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: goldColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                isDark ? AppColors.darkTextSecond : AppColors.lightTextSecond,
          ),
        ),
      ],
    );
  }
}

class _CounterArcPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final Color goldColor;

  const _CounterArcPainter({
    required this.progress,
    required this.isDark,
    required this.goldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final trackPaint = Paint()
      ..color = isDark ? AppColors.darkBorder : AppColors.lightBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = goldColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CounterArcPainter old) =>
      old.progress != progress || old.isDark != isDark;
}
