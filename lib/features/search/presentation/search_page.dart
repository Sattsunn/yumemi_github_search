import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumeimi_github_search/features/search/presentation/widgets/search_bar_section.dart';
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
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final state = ref.read(searchNotifierProvider);

      // 無限スクロール
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          state.hasMore &&
          state.status != SearchStatus.loading) {
        ref
            .read(searchNotifierProvider.notifier)
            .search(_controller.text, loadMore: true);
      }

      // スクロールトップボタンの表示制御
      final shouldShow = _scrollController.offset > 300;
      if (shouldShow != _showScrollToTop) {
        setState(() => _showScrollToTop = shouldShow);
      }
    });
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
          SearchBarSection(),
          const SizedBox(height: 8),

          if (state.repos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _showScrollToTop
                    ? IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      )
                    : const SizedBox(width: 48),
              ],
            ),
          ],

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
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey[800]),
            const SizedBox(height: 16),
            Text(
              '検索キーワードを入力してください',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        );

      case SearchStatus.loading:
        if (state.repos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildRepoList(state);

      case SearchStatus.success:
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
