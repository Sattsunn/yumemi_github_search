import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumeimi_github_search/features/search/provider/search_notifier.dart';
import 'package:yumeimi_github_search/features/search/provider/search_state.dart';
import 'widgets/repo_tile.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final state = ref.read(searchNotifierProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        state.hasMore &&
        state.status != SearchStatus.loading) {
      ref
          .read(searchNotifierProvider.notifier)
          .search(_controller.text, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  onPressed: () {
                    ref
                        .read(searchNotifierProvider.notifier)
                        .search(_controller.text);
                    FocusScope.of(context).unfocus();
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
          Expanded(child: _buildResult(state, isDark)),
        ],
      ),
    );
  }

  Widget _buildResult(SearchState state, bool isDark) {
    if (state.status == SearchStatus.error && state.errorMessage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
        ref.read(searchNotifierProvider.notifier).clearError();
      });
    }

    switch (state.status) {
      case SearchStatus.initial:
        return Center(
          child: Text(
            '検索キーワードを入力してください',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
        );

      case SearchStatus.loading:
        if (state.repos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildRepoList(state);

      case SearchStatus.success:
        return _buildRepoList(state);

      case SearchStatus.error:
        return _buildRepoList(state);
    }
  }

  Widget _buildRepoList(SearchState state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.repos.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.repos.length) {
          return RepoTile(repo: state.repos[index]);
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
