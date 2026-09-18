import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/app_router.dart';
import '../../../shared/widgets/onboarding_layout.dart';
import '../../../shared/widgets/glass_card.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

// ── WHY StatefulWidget? ──────────────────────────────────────
// StatelessWidget is fine when a screen never changes.
// But here, the user taps a language and we need to highlight
// their selection — the screen must CHANGE (update its state).
// StatefulWidget has a companion State class that can call
// setState() to rebuild the UI with new data.
// ────────────────────────────────────────────────────────────

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // This variable tracks which language the user selected.
  // null means nothing is selected yet.
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      title: 'Choose Your\nLanguage',  // \n = line break
      subtitle: 'Select the language for the app interface',
      currentStep: 1,
      totalSteps: 4,
      buttonLabel: 'Continue',

      // The button is only enabled when a language is selected
      isButtonEnabled: _selectedLanguage != null,

      onNext: () {
        // Navigate to the next onboarding screen
        Navigator.pushNamed(context, AppRouter.notificationPrefs);
      },

      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLanguageOption(
            code: 'en',
            name: 'English',
            nativeName: 'English',
            flag: '🇬🇧',
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(
            code: 'fa',
            name: 'Persian',
            nativeName: 'فارسی',
            flag: '🇮🇷',
          ),
        ],
      ),
    );
  }

  // Builds one language option card
  Widget _buildLanguageOption({
    required String code,
    required String name,
    required String nativeName,
    required String flag,
  }) {
    // Is this card the currently selected one?
    final isSelected = _selectedLanguage == code;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        // setState() tells Flutter "something changed, redraw the UI"
        // Inside the callback, we update our variable.
        setState(() {
          _selectedLanguage = code;
        });
      },

      child: AnimatedContainer(
        // AnimatedContainer smoothly animates any property changes
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            // Selected = accent color border. Unselected = subtle border.
            color: isSelected
                ? AppColors.accent
                : theme.colorScheme.onSurface.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.1)
              : theme.colorScheme.surface.withValues(alpha: 0.5),
        ),

        child: Row(
          children: [
            // Flag emoji
            Text(flag, style: const TextStyle(fontSize: 36)),

            const SizedBox(width: 16),

            // Language names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.accent
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    nativeName,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark — only visible when selected
            // AnimatedOpacity fades it in/out smoothly
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1.0 : 0.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}