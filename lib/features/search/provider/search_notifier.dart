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

  SearchNotifier(this.repository)
    : super(
        SearchState(
          sortOption: const RepoSortOption(
            RepoSortField.stars,
            RepoSortOrder.desc,
          ),
        ),
      );
  Future<void> search(String keyword, {bool loadMore = false}) async {
    if (_isThrottled || (keyword.isEmpty && !loadMore)) return;

    _isThrottled = true;

    final nextPage = loadMore ? state.page + 1 : 1;
    final effectiveKeyword = loadMore ? state.keyword : keyword;

    // 新規検索時のみ状態をリセット
    if (!loadMore) {
      state = state.copyWith(
        status: SearchStatus.loading,
        keyword: effectiveKeyword,
        page: 1,
        hasMore: true,
        repos: [],
      );
    }

    try {
      // API呼び出し
      final results = await repository.search(
        effectiveKeyword,
        nextPage,
        state.sortOption,
      );

      // 結果を追加または置き換え
      state = state.copyWith(
        status: SearchStatus.success,
        repos: loadMore ? [...state.repos, ...results] : results,
        keyword: effectiveKeyword,
        page: nextPage,
        hasMore: results.length == 30,
      );
    } catch (e) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      _isThrottled = false;
    }
  }

  void setSortOption(RepoSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void clearError() {
    if (state.status == SearchStatus.error) {
      state = state.copyWith(status: SearchStatus.initial, errorMessage: '');
    }
  }
}
