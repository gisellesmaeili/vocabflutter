// ============================================================
// VOCABULARY SCREEN
// Shows the user's word list. Each word has an English term,
// its Persian translation, and a mastery indicator.
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  // A temporary hardcoded list of words so we can see the UI.
  // Later, this will come from the database.
  final List<Map<String, String>> _words = [
    {
      'word': 'Ephemeral',
      'translation': 'زودگذر',
      'example': 'Fame is ephemeral.',
    },
    {
      'word': 'Resilient',
      'translation': 'انعطاف‌پذیر',
      'example': 'She is resilient in difficult times.',
    },
    {
      'word': 'Eloquent',
      'translation': 'سخنور',
      'example': 'He gave an eloquent speech.',
    },
    {
      'word': 'Ambiguous',
      'translation': 'مبهم',
      'example': 'The instructions were ambiguous.',
    },
    {
      'word': 'Tenacious',
      'translation': 'پایدار',
      'example': 'A tenacious athlete never gives up.',
    },
  ];

  // Search query — what the user types in the search bar
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter words based on search query.
    // where() keeps only items where the condition is true.
    // toLowerCase() makes search case-insensitive.
    final filteredWords = _words.where((word) {
      return word['word']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          word['translation']!.contains(_searchQuery);
    }).toList();

    return Scaffold(
      // backgroundColor is transparent so the gradient shows
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0A0A1A), const Color(0xFF1A0A2E)]
                : [const Color(0xFFE8E8FF), const Color(0xFFFFFFFF)],
          ),
        ),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── HEADER ──────────────────────────────────────
              _buildHeader(theme),

              // ── SEARCH BAR ──────────────────────────────────
              _buildSearchBar(theme, isDark),

              const SizedBox(height: 8),

              // ── WORD LIST ───────────────────────────────────
              // Expanded makes the list take all remaining space
              Expanded(
                child: filteredWords.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        // Padding inside the scrollable area
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),

                        // How many items to show
                        itemCount: filteredWords.length,

                        // Called for each item. 'index' is 0, 1, 2...
                        // ListView.builder is efficient — it only builds
                        // the cards currently visible on screen, not all
                        // of them at once.
                        itemBuilder: (context, index) {
                          return _buildWordCard(
                            filteredWords[index],
                            theme,
                            isDark,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // The floating "+" button to add new words
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Vocabulary',
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 4),
          Text(
            '${_words.length} words',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: TextField(
        // Called every time the user types a character
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },

        decoration: InputDecoration(
          hintText: 'Search words...',
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none, // no visible border line
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(
    Map<String, String> word,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.white.withValues(alpha: 0.8),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),

      child: Row(
        children: [
          // Word info (left side)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // English word
                Text(
                  word['word']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                // Persian translation
                Text(
                  word['translation']!,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                // Example sentence
                Text(
                  word['example']!,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Delete button (right side)
          IconButton(
            onPressed: () {
              // Find the word in the original list and remove it.
              // firstWhere() finds the first item matching a condition.
              setState(() {
                _words.removeWhere((w) => w['word'] == word['word']);
              });
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // Shown when the word list is empty or search has no results
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _searchQuery.isEmpty ? '📚' : '🔍',
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No words yet'
                : 'No results for "$_searchQuery"',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Tap + to add your first word'
                : 'Try a different search term',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddWordDialog(),
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add),
      label: const Text(
        'Add Word',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  // Shows a pop-up dialog to add a new word.
  // A dialog is a modal window that appears on top of the screen.
  void _showAddWordDialog() {
    // TextEditingController lets us read what the user typed
    // in a TextField programmatically.
    final wordController = TextEditingController();
    final translationController = TextEditingController();
    final exampleController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final isDark = theme.brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor: isDark
              ? const Color(0xFF1C1C1E)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Add New Word',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogTextField(
                controller: wordController,
                label: 'English word',
                hint: 'e.g. Eloquent',
              ),
              const SizedBox(height: 12),
              _dialogTextField(
                controller: translationController,
                label: 'Persian translation',
                hint: 'e.g. سخنور',
              ),
              const SizedBox(height: 12),
              _dialogTextField(
                controller: exampleController,
                label: 'Example sentence (optional)',
                hint: 'e.g. She gave an eloquent speech.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Only add if the word field is not empty
                if (wordController.text.trim().isNotEmpty) {
                  setState(() {
                    _words.add({
                      'word': wordController.text.trim(),
                      'translation': translationController.text.trim(),
                      'example': exampleController.text.trim(),
                    });
                  });
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }
}