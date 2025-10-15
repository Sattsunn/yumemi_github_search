import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yumeimi_github_search/features/search/model/github_repo.dart';

class GitHubApi {
  static const String baseUrl = 'https://api.github.com';

  Future<List<GithubRepo>> searchRepositories(
    String keyword, {
    int page = 1,
    int perPage = 30,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/search/repositories?q=$keyword&page=$page&per_page=$perPage',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final items = data['items'] as List<dynamic>;
      return items.map((json) => GithubRepo.fromJson(json)).toList();
    } else if (response.statusCode == 304) {
      throw ('Not Modified');
    } else if (response.statusCode == 403) {
      throw ('API rate limit exceeded, please try again later.');
    } else if (response.statusCode == 422) {
      throw ('Validation failed, or the endpoint has been spammed.');
    } else if (response.statusCode == 503) {
      throw ('Service unavailable, try again later.');
    } else {
      throw ('Failed to fetch repositories: ${response.statusCode}');
    }
  }

  Future<GithubRepo> fetchRepositoryWithSubscribers(
    String owner,
    String repo,
  ) async {
    final uri = Uri.https('api.github.com', '/repos/$owner/$repo');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final repo = GithubRepo.fromJson(data);
      return repo.copyWith(watchers: data['subscribers_count'] ?? 0);
    } else {
      throw Exception('Failed to fetch repository detail');
    }
  }
}
