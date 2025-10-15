import 'package:flutter/material.dart';
import 'package:yumeimi_github_search/features/search/presentation/search_result_page.dart';
import '../../model/github_repo.dart';

class RepoTile extends StatelessWidget {
  final GithubRepo repo;

  const RepoTile({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(repo.ownerAvatarUrl),
        ),
        title: Text(repo.name),
        subtitle: Text('Language: ${repo.language}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${repo.stars}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.call_split, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${repo.forks}'),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SearchResultPage(repo: repo)),
          );
        },
      ),
    );
  }
}
