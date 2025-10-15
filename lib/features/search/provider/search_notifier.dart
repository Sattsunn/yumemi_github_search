import 'package:flutter_riverpod/legacy.dart';
import 'package:yumeimi_github_search/features/search/data/github_api.dart';
import '../data/github_repository.dart';
import 'search_state.dart';

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>(
      (ref) => SearchNotifier(GithubRepositoryImpl(api: GitHubApi())),
    );

class SearchNotifier extends StateNotifier<SearchState> {
  final GithubRepository repository;

  bool _isThrottled = false;

  SearchNotifier(this.repository) : super(SearchState());

  Future<void> search(String keyword, {bool loadMore = false}) async {
    if (_isThrottled || keyword.isEmpty) return;

    _isThrottled = true;
    // api制限を避けるため500msの間隔を空ける
    Future.delayed(const Duration(milliseconds: 500), () {
      _isThrottled = false;
    });

    final nextPage = loadMore ? state.page + 1 : 1;

    if (!loadMore) {
      state = state.copyWith(
        status: SearchStatus.loading,
        page: 1,
        hasMore: true,
        repos: [],
      );
    }

    try {
      final results = await repository.search(keyword, nextPage);

      state = state.copyWith(
        status: SearchStatus.success,
        repos: loadMore ? [...state.repos, ...results] : results,
        page: nextPage,
        hasMore: results.length == 30,
      );
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    if (state.status == SearchStatus.error) {
      state = state.copyWith(status: SearchStatus.initial, errorMessage: '');
    }
  }
}
