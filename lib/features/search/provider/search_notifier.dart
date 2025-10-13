import 'package:flutter_riverpod/legacy.dart';
import 'package:yumeimi_github_search/features/search/data/github_api.dart';
import '../data/github_repository.dart';
import 'search_state.dart';

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>(
      (ref) =>
          SearchNotifier(repository: GithubRepositoryImpl(api: GitHubApi())),
    );

class SearchNotifier extends StateNotifier<SearchState> {
  final GithubRepository repository;

  SearchNotifier({required this.repository}) : super(SearchState());

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) return;

    state = state.copyWith(status: SearchStatus.loading);

    try {
      final results = await repository.search(keyword);
      state = state.copyWith(status: SearchStatus.success, repos: results);
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
