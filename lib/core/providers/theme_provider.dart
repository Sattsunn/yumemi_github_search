import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// アプリ全体のテーマモード管理
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
