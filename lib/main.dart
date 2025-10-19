import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumemi_github_search/app.dart';

void main() {
  runApp(const ProviderScope(child: GitHubSearchApp()));
}
