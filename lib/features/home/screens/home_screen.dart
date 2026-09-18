// ============================================================
// HOME SCREEN — Main Navigation Shell
//
// This screen is a "shell" — it contains the bottom navigation
// bar and swaps the content area depending on which tab is
// selected. Think of it like a TV remote changing channels:
// the TV (shell) stays the same, only the content changes.
// ============================================================

import 'package:flutter/material.dart';
import '../../vocabulary/screens/vocabulary_screen.dart';
import '../../flashcard/screens/flashcard_screen.dart';
import '../../quiz/screens/quiz_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  // StatefulWidget because the selected tab index changes
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Which tab is currently selected? 0 = first tab (Vocabulary)
  int _currentIndex = 0;

  // The list of screens, in the same order as the tabs.
  // 'static const' because these screens don't change —
  // we always have the same 4 screens.
  static const List<Widget> _screens = [
    VocabularyScreen(),
    FlashcardScreen(),
    QuizScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // IndexedStack keeps all screens alive in memory.
      // Unlike a regular PageView, IndexedStack doesn't destroy
      // a screen when you switch tabs — it just hides it.
      // This means if you scroll down in Vocabulary, switch to
      // Quiz, then come back — you're still scrolled to the same
      // position. Much better UX.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // The bottom navigation bar
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      // A subtle top border to separate it from the content
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
        // Slight blur effect on the nav bar (glassmorphism)
        color: isDark
            ? const Color(0xFF0A0A1A).withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
      ),

      child: BottomNavigationBar(
        currentIndex: _currentIndex,

        // Called when user taps a tab.
        // 'index' is the index of the tab they tapped (0, 1, 2, or 3).
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        // 'fixed' means all tabs are always visible and same width.
        // Alternative is 'shifting' where selected tab expands.
        type: BottomNavigationBarType.fixed,

        // Colors
        selectedItemColor: AppColors.accent,
        unselectedItemColor: isDark
            ? Colors.white.withValues(alpha: 0.4)
            : Colors.black.withValues(alpha: 0.35),

        // Remove the default white/gray background
        backgroundColor: Colors.transparent,
        elevation: 0,

        // Font sizes
        selectedFontSize: 11,
        unselectedFontSize: 11,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'Vocabulary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_outlined),
            activeIcon: Icon(Icons.style),
            label: 'Flashcards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}