import 'github_api.dart';
import 'package:yumeimi_github_search/features/search/model/github_repo.dart';

abstract class GithubRepository {
  Future<List<GithubRepo>> search(String keyword, int page);
}

class GithubRepositoryImpl implements GithubRepository {
  final GitHubApi api;

  GithubRepositoryImpl({required this.api});

  @override
  Future<List<GithubRepo>> search(String keyword, int page) async {
    return await api.searchRepositories(keyword, page: page);
  }
}
