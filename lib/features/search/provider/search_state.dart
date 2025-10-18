import '../model/github_repo.dart';

enum SearchStatus { initial, loading, success, error }

enum RepoSortField { stars, forks }

enum RepoSortOrder { asc, desc }

class RepoSortOption {
  final RepoSortField field;
  final RepoSortOrder order;
  const RepoSortOption(this.field, this.order);

  String get displayName {
    final fieldName = field == RepoSortField.stars ? 'Stars' : 'Forks';
    final orderName = order == RepoSortOrder.asc ? '↑' : '↓';
    return '$fieldName $orderName';
  }
}

class SearchState {
  final List<GithubRepo> repos;
  final SearchStatus status;
  final String errorMessage;
  final String keyword;
  final int page;
  final bool hasMore;
  final RepoSortOption sortOption;
  final String? selectedLanguage;

  SearchState({
    this.repos = const [],
    this.status = SearchStatus.initial,
    this.errorMessage = '',
    this.keyword = '',
    this.page = 1,
    this.hasMore = true,
    this.sortOption = const RepoSortOption(
      RepoSortField.stars,
      RepoSortOrder.desc,
    ),
    this.selectedLanguage,
  });

  SearchState copyWith({
    List<GithubRepo>? repos,
    SearchStatus? status,
    String? errorMessage,
    String? keyword,
    int? page,
    bool? hasMore,
    RepoSortOption? sortOption,
    String? selectedLanguage,
  }) {
    return SearchState(
      repos: repos ?? this.repos,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      keyword: keyword ?? this.keyword,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      sortOption: sortOption ?? this.sortOption,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
