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
}
