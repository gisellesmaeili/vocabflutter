// ============================================================
// WELCOME SCREEN
// This is the first screen users see when they open the app.
// It shows the app name, a tagline, and a "Get Started" button.
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  // 'const' here means this widget can be created at compile time
  // (before the app even runs), which makes it faster.
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery gives us information about the screen.
    // Here we get the screen's height so we can size things proportionally.
    final screenHeight = MediaQuery.of(context).size.height;

    // Theme.of(context) gives us access to the current theme
    // (light or dark). We store it in a variable for convenience.
    final theme = Theme.of(context);

    // isDark tells us whether we're currently in dark mode.
    // We'll use this to choose slightly different colors/opacity
    // for the glass effect depending on the mode.
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // extendBodyBehindAppBar: true means the background goes all
      // the way to the top of the screen, behind the status bar.
      // This gives a full-bleed look.
      extendBodyBehindAppBar: true,

      body: Stack(
        // Stack is like layers in Photoshop.
        // Children are drawn in order: first child = bottom layer.
        children: [
          // ── LAYER 1: Background Gradient ──────────────────────
          // This fills the entire screen with a gradient.
          _buildBackground(isDark),

          // ── LAYER 2: Main Content ──────────────────────────────
          // SafeArea pushes content away from the notch, home
          // indicator, and status bar on all devices.
          SafeArea(
            child: Padding(
              // Padding adds space around its child.
              // EdgeInsets.symmetric(horizontal: 28) means
              // 28px of space on the left AND right.
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                // Column stacks its children vertically (top to bottom).
                // mainAxisAlignment controls vertical positioning.
                // center = everything is centered vertically.
                mainAxisAlignment: MainAxisAlignment.center,

                // crossAxisAlignment controls horizontal positioning.
                // center = everything is centered horizontally.
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  // Push content down a little from the true center
                  SizedBox(height: screenHeight * 0.05),

                  // ── APP ICON ─────────────────────────────────
                  _buildAppIcon(isDark),

                  // SizedBox is just empty space.
                  // Think of it like pressing Enter to add a blank line.
                  const SizedBox(height: 32),

                  // ── APP NAME ─────────────────────────────────
                  _buildAppName(theme),

                  const SizedBox(height: 16),

                  // ── TAGLINE ───────────────────────────────────
                  _buildTagline(theme),

                  const SizedBox(height: 64),

                  // ── GET STARTED BUTTON ────────────────────────
                  _buildGetStartedButton(context, isDark),

                  const SizedBox(height: 24),

                  // ── SIGN IN LINK ──────────────────────────────
                  _buildSignInText(context, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPER METHODS
  // Instead of cramming everything into build(), we break the UI
  // into smaller named methods. This makes the code readable.
  // Each method returns a Widget.
  // ============================================================

  // Builds the full-screen gradient background
  Widget _buildBackground(bool isDark) {
    return Container(
      // double.infinity means "take up as much space as possible"
      // — in this case, the full width and height of the screen.
      width: double.infinity,
      height: double.infinity,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          // begin and end define the direction of the gradient.
          // topLeft → bottomRight means it goes diagonally.
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: isDark
              ? [
                  // Dark mode: deep blue-black to purple-black
                  const Color(0xFF0A0A1A),
                  const Color(0xFF1A0A2E),
                  const Color(0xFF0A1628),
                ]
              : [
                  // Light mode: soft lavender to light blue-white
                  const Color(0xFFE8E8FF),
                  const Color(0xFFF0F4FF),
                  const Color(0xFFFFFFFF),
                ],
        ),
      ),
    );
  }

  // Builds the app icon (a glass-effect circle with a book emoji)
  Widget _buildAppIcon(bool isDark) {
    return Container(
      width: 120,
      height: 120,

      decoration: BoxDecoration(
        // Makes the container a perfect circle
        shape: BoxShape.circle,

        // The glass effect: a semi-transparent white/dark fill
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.7),

        // A subtle border to reinforce the glass look
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.9),
          width: 1.5,
        ),

        // Shadow gives depth — makes it feel like it's floating
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),

      // The emoji inside the circle
      child: const Center(
        child: Text(
          '📚',
          style: TextStyle(fontSize: 52),
        ),
      ),
    );
  }

  // Builds the app name text
  Widget _buildAppName(ThemeData theme) {
    return Text(
      'VocabApp',
      style: theme.textTheme.displayLarge?.copyWith(
        // copyWith lets you take an existing style and change
        // just specific properties, keeping everything else.
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: AppColors.accent,
        letterSpacing: 1.2,
      ),
    );
  }

  // Builds the tagline below the app name
  Widget _buildTagline(ThemeData theme) {
    return Text(
      'Learn English vocabulary\nthe smart way',

      // textAlign centers the text horizontally within its box
      textAlign: TextAlign.center,

      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 18,
        // onSurface is the theme's default text color (auto-adapts
        // to light/dark mode)
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.6, // line height for comfortable reading
      ),
    );
  }

  // Builds the main "Get Started" button
  Widget _buildGetStartedButton(BuildContext context, bool isDark) {
    return Container(
      // The button takes full available width (minus the 28px
      // padding we added to the Column)
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),

        // A glowing shadow behind the button using the accent color
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8), // shadow is 8px below the button
          ),
        ],
      ),

      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.languageSelection);
        },

        // The style is already defined in AppTheme,
        // but we override the padding here for this specific button.
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),

        child: const Text('Get Started'),
      ),
    );
  }

  // Builds the "Already have an account? Sign in" text at the bottom
  Widget _buildSignInText(BuildContext context, ThemeData theme) {
    return Row(
      // Row places its children horizontally (side by side)
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have a word list? ',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 15,
          ),
        ),

        // GestureDetector makes any widget tappable.
        // Here we wrap a Text in it to make a tappable link.
        GestureDetector(
          onTap: () {
            // Sign in navigation will go here later
          },
          child: Text(
            'Import it',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}