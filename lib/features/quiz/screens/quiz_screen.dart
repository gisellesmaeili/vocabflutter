// ============================================================
// QUIZ SCREEN
// Multiple choice quiz. 4 options, one correct answer.
// User taps an option, gets instant feedback, then moves on.
// ============================================================

import 'dart:math'; // for Random()
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, String>> _words = [
    {'word': 'Ephemeral', 'translation': 'زودگذر'},
    {'word': 'Resilient', 'translation': 'انعطاف‌پذیر'},
    {'word': 'Eloquent', 'translation': 'سخنور'},
    {'word': 'Ambiguous', 'translation': 'مبهم'},
    {'word': 'Tenacious', 'translation': 'پایدار'},
  ];

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;  // Which option the user tapped (null = none yet)
  bool _hasAnswered = false;  // Has user tapped an option?
  late List<String> _options; // The 4 options for the current question

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  // Builds 4 options: 1 correct + 3 random wrong answers
  void _generateOptions() {
    final correctWord = _words[_currentIndex];
    final random = Random();

    // Get 3 wrong answers — words that are NOT the correct one
    final wrongWords = _words
        .where((w) => w['word'] != correctWord['word'])
        .toList()
      ..shuffle(random); // shuffle randomly

    // Take only 3 wrong answers
    final wrongOptions = wrongWords
        .take(3)
        .map((w) => w['translation']!)
        .toList();

    // Combine correct + wrong, then shuffle so correct isn't always first
    _options = [correctWord['translation']!, ...wrongOptions]
      ..shuffle(random);
  }

  void _selectOption(int index) {
    if (_hasAnswered) return; // ignore taps after already answering

    final correct = _options[index] == _words[_currentIndex]['translation'];
    if (correct) _score++;

    setState(() {
      _selectedOptionIndex = index;
      _hasAnswered = true;
    });

    // Wait 1.2 seconds then move to next question
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return; // safety check — widget might be gone
      if (_currentIndex < _words.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOptionIndex = null;
          _hasAnswered = false;
        });
        _generateOptions();
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          _score == _words.length ? '🏆 Perfect!' : '📊 Results',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You scored $_score out of ${_words.length}.\n\n'
          '${_getResultMessage()}',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _selectedOptionIndex = null;
                _hasAnswered = false;
              });
              _generateOptions();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  String _getResultMessage() {
    final percentage = (_score / _words.length * 100).round();
    if (percentage == 100) return 'Outstanding! 🌟';
    if (percentage >= 80) return 'Great job! Keep it up.';
    if (percentage >= 60) return 'Good effort! Review the ones you missed.';
    return 'Keep practicing — you\'ll get there!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final word = _words[_currentIndex];

    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header
                Text(
                  'Quiz',
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 30),
                ),

                const SizedBox(height: 4),

                Text(
                  'Question ${_currentIndex + 1} of ${_words.length}  •  Score: $_score',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Progress bar
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / _words.length,
                  backgroundColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.accent),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 4,
                ),

                const SizedBox(height: 40),

                // Question card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent,
                        AppColors.accent.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.35),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'What is the meaning of',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        word['word']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Answer options
                ...List.generate(_options.length, (index) {
                  return _buildOptionCard(index, theme, isDark);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, ThemeData theme, bool isDark) {
    // Determine the color of this option card
    Color? cardColor;
    Color? borderColor;

    if (_hasAnswered) {
      final isCorrect = _options[index] == _words[_currentIndex]['translation'];
      final isSelected = index == _selectedOptionIndex;

      if (isCorrect) {
        // Always highlight the correct answer in green
        cardColor = Colors.green.withValues(alpha: 0.2);
        borderColor = Colors.green;
      } else if (isSelected) {
        // Highlight wrong selection in red
        cardColor = Colors.red.withValues(alpha: 0.15);
        borderColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardColor ??
              (isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : Colors.white.withValues(alpha: 0.8)),
          border: Border.all(
            color: borderColor ??
                (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08)),
            width: borderColor != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Option letter (A, B, C, D)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // 65 = 'A' in ASCII
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              _options[index],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}