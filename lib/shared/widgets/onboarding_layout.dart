// ============================================================
// ONBOARDING LAYOUT
// A reusable layout for all onboarding screens.
// Every onboarding screen uses this as its outer shell,
// passing in its specific content as a child.
// ============================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'glass_card.dart';

class OnboardingLayout extends StatelessWidget {
  final String title;           // Screen title (e.g. "Choose Language")
  final String subtitle;        // Smaller text below the title
  final Widget content;         // The unique content for each screen
  final String buttonLabel;     // Text on the next/continue button
  final VoidCallback onNext;    // What happens when button is pressed
  final int currentStep;        // Which step we're on (1, 2, 3...)
  final int totalSteps;         // Total number of onboarding steps
  final bool isButtonEnabled;   // Whether the button can be pressed

  const OnboardingLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.buttonLabel,
    required this.onNext,
    required this.currentStep,
    required this.totalSteps,
    this.isButtonEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background gradient (same as welcome screen)
          _buildBackground(isDark),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ── PROGRESS INDICATOR ──────────────────────
                  // Shows "Step 1 of 4" with a visual progress bar
                  _buildProgressIndicator(theme),

                  const SizedBox(height: 32),

                  // ── TITLE ───────────────────────────────────
                  Text(
                    title,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 32,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── SUBTITLE ────────────────────────────────
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── MAIN CONTENT ────────────────────────────
                  // 'Expanded' tells this widget to take up all
                  // remaining vertical space between the title
                  // and the button below.
                  Expanded(child: content),

                  const SizedBox(height: 24),

                  // ── NEXT BUTTON ─────────────────────────────
                  _buildNextButton(context, isDark),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0A0A1A),
                  const Color(0xFF1A0A2E),
                  const Color(0xFF0A1628),
                ]
              : [
                  const Color(0xFFE8E8FF),
                  const Color(0xFFF0F4FF),
                  const Color(0xFFFFFFFF),
                ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Step 1 of 4" text
        Text(
          'Step $currentStep of $totalSteps',
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 8),

        // The progress bar itself
        // LayoutBuilder gives us the available width
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            // How wide each filled segment should be
            final filledWidth = (totalWidth / totalSteps) * currentStep;

            return Stack(
              children: [
                // Background (unfilled) bar
                Container(
                  height: 4,
                  width: totalWidth,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Filled portion
                // AnimatedContainer smoothly animates width changes
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  width: filledWidth,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context, bool isDark) {
    return AnimatedOpacity(
      // AnimatedOpacity fades the button in/out when
      // isButtonEnabled changes
      duration: const Duration(milliseconds: 200),
      opacity: isButtonEnabled ? 1.0 : 0.4,

      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: isButtonEnabled
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          // If button is disabled, onPressed is null.
          // A null onPressed automatically disables the button in Flutter.
          onPressed: isButtonEnabled ? onNext : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          child: Text(buttonLabel),
        ),
      ),
    );
  }
}