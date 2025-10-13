import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yumeimi_github_search/features/search/model/github_repo.dart';

class GitHubApi {
  static const String baseUrl = 'https://api.github.com';

  Future<List<GithubRepo>> searchRepositories(String keyword) async {
    final uri = Uri.https('api.github.com', '/search/repositories', {
      'q': keyword,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final items = data['items'] as List<dynamic>;
      return items.map((json) => GithubRepo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch repositories: ${response.statusCode}');
    }
  }
}
