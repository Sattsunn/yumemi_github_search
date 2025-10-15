import 'package:flutter/material.dart';
import 'package:yumeimi_github_search/core/ui/custom_app_bar.dart';
import 'package:yumeimi_github_search/features/search/model/github_repo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchResultPage extends StatelessWidget {
  final GithubRepo repo;

  const SearchResultPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(repo.ownerAvatarUrl),
            ),
            const SizedBox(height: 16),
            Text(
              repo.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Owner: ${repo.ownerName}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(Icons.star, 'Stars', repo.stars, Colors.amber),
                    _buildStat(
                      FontAwesomeIcons.eye,
                      'Watch',
                      repo.watchers,
                      Colors.blue,
                    ),
                    _buildStat(
                      FontAwesomeIcons.codeBranch,
                      'Forks',
                      repo.forks,
                      Colors.green,
                    ),
                    _buildStat(
                      Icons.error_outline,
                      'Issues',
                      repo.issues,
                      Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.language, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      repo.language,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
