import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yumeimi_github_search/features/search/presentation/widgets/language_dropdown.dart';
import 'package:yumeimi_github_search/features/search/presentation/widgets/sort_dropdown.dart';
import 'package:yumeimi_github_search/features/search/provider/search_notifier.dart';
import 'package:yumeimi_github_search/core/providers/theme_provider.dart';

class SearchBarSection extends ConsumerWidget {
  final TextEditingController queryController;
  final TextEditingController languageController;

  const SearchBarSection({
    super.key,
    required this.queryController,
    required this.languageController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

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
            controller: queryController,
            decoration: InputDecoration(
              hintText: 'リポジトリを検索',
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
              prefixIcon: const Icon(Icons.search),
              suffixIcon: queryController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        queryController.clear();
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

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 言語選択
                  SizedBox(
                    width: isNarrow ? double.infinity : 180,
                    child: LanguageDropdown(
                      selectedLanguage: languageController.text,
                      onChanged: (String? language) {
                        languageController.text = language ?? '';
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: isNarrow
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SortDropdown(
                                  selectedOption: state.sortOption,
                                  onChanged: (option) =>
                                      notifier.setSortOption(option!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: queryController,
                                builder: (context, value, _) {
                                  final isEmpty = value.text.trim().isEmpty;
                                  return SizedBox(
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      onPressed: isEmpty
                                          ? null
                                          : () {
                                              notifier.search(
                                                queryController.text,
                                                languageController.text,
                                                loadMore: false,
                                              );
                                              FocusScope.of(context).unfocus();
                                            },
                                      label: const Text('検索'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isEmpty
                                            ? (isDark
                                                  ? Colors.grey[700]
                                                  : Colors.grey[300])
                                            : (isDark
                                                  ? Colors.grey[100]
                                                  : Colors.black),
                                        foregroundColor: isEmpty
                                            ? Colors.grey[500]
                                            : (isDark
                                                  ? Colors.black
                                                  : Colors.white),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: SortDropdown(
                                  selectedOption: state.sortOption,
                                  onChanged: (option) =>
                                      notifier.setSortOption(option!),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: queryController,
                                builder: (context, value, _) {
                                  final isEmpty = value.text.trim().isEmpty;
                                  return SizedBox(
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      onPressed: isEmpty
                                          ? null
                                          : () {
                                              notifier.search(
                                                queryController.text,
                                                languageController.text,
                                                loadMore: false,
                                              );
                                              FocusScope.of(context).unfocus();
                                            },
                                      label: const Text('検索'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isEmpty
                                            ? (isDark
                                                  ? Colors.grey[700]
                                                  : Colors.grey[300])
                                            : (isDark
                                                  ? Colors.grey[100]
                                                  : Colors.black),
                                        foregroundColor: isEmpty
                                            ? Colors.grey[500]
                                            : (isDark
                                                  ? Colors.black
                                                  : Colors.white),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
