// lib/home.dart
import 'package:flutter/material.dart';
import 'core/ui/custom_app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'GitHub Repository Search'),
    );
  }
}
