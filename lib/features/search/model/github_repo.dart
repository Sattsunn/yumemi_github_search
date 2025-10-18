class GithubRepo {
  final String name;
  final String ownerName;
  final String ownerAvatarUrl;
  final String language;
  final int stars;
  final int watchers;
  final int forks;
  final int issues;

  GithubRepo({
    required this.name,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.language,
    required this.stars,
    required this.watchers,
    required this.forks,
    required this.issues,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      name: json['name'] ?? '',
      ownerName: json['owner']['login'] ?? '',
      ownerAvatarUrl: json['owner']['avatar_url'] ?? '',
      language: json['language'] ?? 'Unknown',
      stars: json['stargazers_count'] ?? 0,
      watchers: json['watchers_count'] ?? 0,
      forks: json['forks_count'] ?? 0,
      issues: json['open_issues_count'] ?? 0,
    );
  }

  GithubRepo copyWith({
    String? name,
    String? ownerName,
    String? ownerAvatarUrl,
    String? language,
    int? stars,
    int? watchers,
    int? forks,
    int? issues,
  }) {
    return GithubRepo(
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatarUrl: ownerAvatarUrl ?? this.ownerAvatarUrl,
      language: language ?? this.language,
      stars: stars ?? this.stars,
      watchers: watchers ?? this.watchers,
      forks: forks ?? this.forks,
      issues: issues ?? this.issues,
    );
  }
}
