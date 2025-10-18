import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final String? selectedLanguage;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  static const List<String> languages = [
    'Dart',
    'Python',
    'JavaScript',
    'TypeScript',
    'C++',
    'C',
    'Java',
    'Go',
    'Rust',
    'Swift',
    'Kotlin',
    'PHP',
    'Ruby',
    'Scala',
    'Haskell',
    'Elixir',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.toLowerCase();

        if (query.isEmpty) {
          // 空文字の場合は全候補を返す
          return languages;
        }

        // 入力に近い順にソート
        final matches = languages.where((lang) {
          return lang.toLowerCase().contains(query);
        }).toList();

        matches.sort((a, b) {
          final aLower = a.toLowerCase();
          final bLower = b.toLowerCase();
          if (aLower.startsWith(query) && !bLower.startsWith(query)) return -1;
          if (!aLower.startsWith(query) && bLower.startsWith(query)) return 1;
          return aLower.compareTo(bLower); // アルファベット順
        });

        return matches;
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, textController, focusNode, onSubmit) {
        // 初回のみ selectedLanguage を反映
        if (textController.text.isEmpty && selectedLanguage != null) {
          textController.text = selectedLanguage!;
        }

        return TextField(
          controller: textController,
          focusNode: focusNode,
          onChanged: (value) => onChanged(value.isEmpty ? null : value),
          decoration: InputDecoration(
            labelText: '言語（入力または選択）',
            hintText: '例: Python, Java...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            prefixIcon: const Icon(Icons.language),
            suffixIcon: textController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      textController.clear();
                      onChanged(null);
                    },
                  )
                : null,
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
