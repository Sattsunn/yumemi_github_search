import 'package:flutter/material.dart';
import 'home.dart';

class GitHubSearchApp extends StatelessWidget {
  const GitHubSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Search',
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}
