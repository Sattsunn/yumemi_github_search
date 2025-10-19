import 'package:flutter/material.dart';
import 'package:yumemi_github_search/features/search/provider/search_state.dart';

class SortDropdown extends StatelessWidget {
  final RepoSortOption selectedOption;
  final ValueChanged<RepoSortOption?> onChanged;

  const SortDropdown({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  static const List<RepoSortOption> options = [
    RepoSortOption(RepoSortField.stars, RepoSortOrder.desc),
    RepoSortOption(RepoSortField.stars, RepoSortOrder.asc),
    RepoSortOption(RepoSortField.forks, RepoSortOrder.desc),
    RepoSortOption(RepoSortField.forks, RepoSortOrder.asc),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<RepoSortOption>(
      value: selectedOption,
      onChanged: onChanged,
      items: options.map((option) {
        return DropdownMenuItem(value: option, child: Text(option.displayName));
      }).toList(),
    );
  }
}
