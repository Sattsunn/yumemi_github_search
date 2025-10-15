import '../model/github_repo.dart';

enum SearchStatus { initial, loading, success, error }

class SearchState {
  final SearchStatus status;
  final List<GithubRepo> repos;
  final String errorMessage;
  final int page;
  final bool hasMore;

  SearchState({
    this.status = SearchStatus.initial,
    this.repos = const [],
    this.errorMessage = '',
    this.page = 1,
    this.hasMore = true,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<GithubRepo>? repos,
    String? errorMessage,
    int? page,
    bool? hasMore,
  }) {
    return SearchState(
      status: status ?? this.status,
      repos: repos ?? this.repos,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
