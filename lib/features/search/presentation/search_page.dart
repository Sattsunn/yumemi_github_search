import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumeimi_github_search/core/providers/theme_provider.dart';
import 'package:yumeimi_github_search/features/search/provider/search_state.dart';
import '../provider/search_notifier.dart';
import 'widgets/repo_tile.dart';
import '../model/github_repo.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'キーワードを入力',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                ref
                                    .read(searchNotifierProvider.notifier)
                                    .search('');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => {
                    ref
                        .read(searchNotifierProvider.notifier)
                        .search(_controller.text),
                    FocusScope.of(context).unfocus(),
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: isDark ? Colors.white : Colors.black87,
                    elevation: 0,
                  ),
                  child: Text(
                    '検索',
                    style: TextStyle(
                      color: isDark ? Colors.black87 : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildResult(state)),
        ],
      ),
    );
  }

  Widget _buildResult(SearchState state) {
    switch (state.status) {
      case SearchStatus.initial:
        return const Center(child: Text('検索キーワードを入力してください'));
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.success:
        return ListView.builder(
          itemCount: state.repos.length,
          itemBuilder: (context, index) {
            final GithubRepo repo = state.repos[index];
            return RepoTile(repo: repo);
          },
        );
      case SearchStatus.error:
        return Center(child: Text('エラー: ${state.errorMessage}'));
    }
  }
}
