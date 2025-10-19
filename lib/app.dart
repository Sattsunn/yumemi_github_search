import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_github_search/core/providers/theme_provider.dart';
import 'core/theme.dart';
import 'features/search/presentation/search_page.dart';

class GitHubSearchApp extends ConsumerWidget {
  const GitHubSearchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'GitHub Search',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SearchPage(),
    );
  }
}
