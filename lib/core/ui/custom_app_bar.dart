import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_github_search/core/providers/theme_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  bool _isDark(BuildContext context, ThemeMode mode) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return mode == ThemeMode.dark ||
        (mode == ThemeMode.system && brightness == Brightness.dark);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = _isDark(context, themeMode);

    return AppBar(
      title: Row(
        children: [
          _Logo(isDark: isDark),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'GitHub Repository Search',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      elevation: 4,
      shadowColor: Colors.black26,
      centerTitle: false,
      actions: [_ThemeToggleButton(isDark: isDark)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Logo extends StatelessWidget {
  final bool isDark;
  const _Logo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.code,
        size: 18,
        color: isDark ? Colors.black : Colors.white,
      ),
    );
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  final bool isDark;
  const _ThemeToggleButton({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        isDark ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
        color: isDark ? Colors.yellowAccent : Colors.black87,
      ),
      onPressed: () {
        ref.read(themeModeProvider.notifier).state = isDark
            ? ThemeMode.light
            : ThemeMode.dark;
      },
    );
  }
}
