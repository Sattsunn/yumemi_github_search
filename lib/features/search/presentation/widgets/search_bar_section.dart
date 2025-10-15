import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumeimi_github_search/features/search/presentation/widgets/sort_dropdown.dart';
import 'package:yumeimi_github_search/features/search/provider/search_notifier.dart';
import 'package:yumeimi_github_search/core/providers/theme_provider.dart';

class SearchBarSection extends ConsumerStatefulWidget {
  const SearchBarSection({super.key});

  @override
  ConsumerState<SearchBarSection> createState() => _SearchBarSectionState();
}

class _SearchBarSectionState extends ConsumerState<SearchBarSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

    final notifier = ref.read(searchNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 検索フィールド
          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'リポジトリを検索',
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {});
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 並び替え + 検索ボタン
          Row(
            children: [
              Expanded(
                child: SortDropdown(
                  selectedOption: state.sortOption,
                  onChanged: (option) => notifier.setSortOption(option!),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _controller.text.trim().isEmpty
                      ? null
                      : () {
                          notifier.search(_controller.text);
                          FocusScope.of(context).unfocus();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _controller.text.trim().isEmpty
                        ? (isDark ? Colors.grey[700] : Colors.grey[300])
                        : (isDark ? Colors.grey[100] : Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(
                    '検索',
                    style: TextStyle(
                      color: _controller.text.trim().isEmpty
                          ? Colors.grey[500]
                          : (isDark ? Colors.black : Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
