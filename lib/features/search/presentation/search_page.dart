import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumeimi_github_search/core/ui/custom_app_bar.dart';
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
  final TextEditingController _languageController = TextEditingController();
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
            .search(_controller.text, _languageController.text, loadMore: true);
      }

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
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: state.repos.length + 2 + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchBarSection(
                      queryController: _controller,
                      languageController: _languageController,
                    ),
                  );
                } else if (index == 1) {
                  if (state.status == SearchStatus.initial) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 64,
                          color: Colors.grey[800],
                        ),
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
                  } else if (state.status == SearchStatus.success &&
                      state.repos.isEmpty) {
                    // 検索結果0件
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '検索結果がありませんでした',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                } else if (index - 2 < state.repos.length) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: RepoTile(repo: state.repos[index - 2]),
                  );
                } else {
                  if (state.status != SearchStatus.initial) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),

            // スクロールトップボタン
            if (_showScrollToTop)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
