import 'package:yumemi_github_search/features/search/provider/search_state.dart';
import 'github_api.dart';
import 'package:yumemi_github_search/features/search/model/github_repo.dart';

abstract class GithubRepository {
  Future<List<GithubRepo>> search(
    String keyword,
    int page,
    RepoSortOption sortOption,
    String? selectedLanguage,
  );
}

class GithubRepositoryImpl implements GithubRepository {
  final GitHubApi api;

  GithubRepositoryImpl({required this.api});

  @override
  Future<List<GithubRepo>> search(
    String keyword,
    int page,
    RepoSortOption sortOption,
    String? selectedLanguage,
  ) async {
    return await api.search(keyword, page, sortOption, selectedLanguage);
  }
}
