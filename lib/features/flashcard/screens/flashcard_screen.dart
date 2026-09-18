// ============================================================
// FLASHCARD SCREEN
// Shows one word at a time as a card. User taps to flip it
// and reveal the translation. Then marks Know / Don't Know.
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin is required for animations.
  // Think of it as giving the widget a "heartbeat" that drives
  // the animation forward frame by frame.

  // Our word list (same temp data as vocabulary screen)
  final List<Map<String, String>> _words = [
    {'word': 'Ephemeral', 'translation': 'زودگذر', 'example': 'Fame is ephemeral.'},
    {'word': 'Resilient', 'translation': 'انعطاف‌پذیر', 'example': 'She is resilient.'},
    {'word': 'Eloquent', 'translation': 'سخنور', 'example': 'An eloquent speaker.'},
    {'word': 'Ambiguous', 'translation': 'مبهم', 'example': 'The message was ambiguous.'},
    {'word': 'Tenacious', 'translation': 'پایدار', 'example': 'A tenacious athlete.'},
  ];

  int _currentIndex = 0;  // Which card we're on
  bool _isFlipped = false; // Is the card showing the back (translation)?
  int _knownCount = 0;    // How many words user marked as "Know"

  // AnimationController drives the flip animation.
  // It goes from 0.0 to 1.0, and we map that range to a rotation.
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    // initState() is called once when the widget is first created.
    // It's where you set up things that need to exist before build().
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this, // 'this' refers to SingleTickerProviderStateMixin
    );

    // Tween maps the animation value (0→1) to a number range (0→1).
    // We'll use this to drive a rotation from 0 to π (180 degrees).
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // dispose() is called when the widget is removed from the screen.
    // Always dispose controllers to free memory. This is important —
    // forgetting to dispose causes memory leaks.
    _flipController.dispose();
    super.dispose();
  }

  // Flips the card
  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse(); // animate backwards (back to front)
    } else {
      _flipController.forward(); // animate forwards (front to back)
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  // Go to the next card
  void _nextCard({required bool known}) {
    if (known) _knownCount++;

    if (_currentIndex < _words.length - 1) {
      setState(() {
        _currentIndex++;
        _isFlipped = false;
      });
      _flipController.reset(); // reset animation to "front" position
    } else {
      // No more cards — show results
      _showResultsDialog();
    }
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button to dismiss
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Session Complete! 🎉',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'You knew $_knownCount out of ${_words.length} words.\n\n'
          '${_knownCount == _words.length ? "Perfect score! 🌟" : "Keep practicing!"}',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Reset to start
              setState(() {
                _currentIndex = 0;
                _isFlipped = false;
                _knownCount = 0;
              });
              _flipController.reset();
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
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
          child: Column(
            children: [
              // ── HEADER ──────────────────────────────────────
              _buildHeader(theme),

              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LinearProgressIndicator(
                  // value is between 0.0 and 1.0
                  value: (_currentIndex + 1) / _words.length,
                  backgroundColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.accent),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 4,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card ${_currentIndex + 1} of ${_words.length}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '✓ $_knownCount known',
                      style: TextStyle(
                        color: Colors.green.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── FLASHCARD ────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: _flipCard,
                    child: AnimatedBuilder(
                      // AnimatedBuilder rebuilds every time the
                      // animation value changes (every frame)
                      animation: _flipAnimation,
                      builder: (context, child) {
                        // _flipAnimation.value goes from 0 to 1.
                        // We multiply by π to get 0 to 180 degrees.
                        final angle = _flipAnimation.value * 3.14159;

                        // When angle > π/2 (90 degrees), we're
                        // looking at the "back" of the card.
                        final isShowingBack = angle > 1.5708;

                        return Transform(
                          // Rotate around the Y axis (horizontal flip)
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // perspective
                            ..rotateY(angle),
                          alignment: Alignment.center,
                          child: isShowingBack
                              ? Transform(
                                  // Counter-rotate the back content so
                                  // it isn't mirrored
                                  transform: Matrix4.identity()
                                    ..rotateY(3.14159),
                                  alignment: Alignment.center,
                                  child: _buildCardBack(word, theme, isDark),
                                )
                              : _buildCardFront(word, theme, isDark),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── KNOW / DON'T KNOW BUTTONS ───────────────────
              _buildActionButtons(isDark),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Text(
            'Flashcards',
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
          ),
          const Spacer(), // pushes the icon to the right
          Icon(
            Icons.style,
            color: AppColors.accent,
            size: 28,
          ),
        ],
      ),
    );
  }

  // Front of the card — shows the English word
  Widget _buildCardFront(
    Map<String, String> word,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent,
            AppColors.accent.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word['word']!,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            word['example']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Tap to reveal translation',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Back of the card — shows the Persian translation
  Widget _buildCardBack(
    Map<String, String> word,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: isDark ? const Color(0xFF1C1C2E) : Colors.white,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🇮🇷',
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 24),
          Text(
            word['translation']!,
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            word['word']!,
            style: TextStyle(
              fontSize: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Don't Know button
          Expanded(
            child: GestureDetector(
              onTap: () => _nextCard(known: false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: const Column(
                  children: [
                    Text('✗', style: TextStyle(fontSize: 24, color: Colors.red)),
                    SizedBox(height: 4),
                    Text(
                      "Don't Know",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Know button
          Expanded(
            child: GestureDetector(
              onTap: () => _nextCard(known: true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: const Column(
                  children: [
                    Text('✓', style: TextStyle(fontSize: 24, color: Colors.green)),
                    SizedBox(height: 4),
                    Text(
                      'Know',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}