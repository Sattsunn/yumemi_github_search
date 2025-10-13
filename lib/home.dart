import 'package:flutter/material.dart';
import 'package:yumeimi_github_search/features/search/presentation/search_page.dart';
import 'core/ui/custom_app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'GitHub Repository Search'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: const SearchPage(),
      ),
    );
  }
}
