import '../model/github_repo.dart';

enum SearchStatus { initial, loading, success, error }

class SearchState {
  final SearchStatus status;
  final List<GithubRepo> repos;
  final String errorMessage;

  SearchState({
    this.status = SearchStatus.initial,
    this.repos = const [],
    this.errorMessage = '',
  });

  SearchState copyWith({
    SearchStatus? status,
    List<GithubRepo>? repos,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      repos: repos ?? this.repos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
