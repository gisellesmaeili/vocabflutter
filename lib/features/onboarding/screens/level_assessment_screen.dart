import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/app_router.dart';
import '../../../shared/widgets/onboarding_layout.dart';

// The possible levels a user can select
enum EnglishLevel { beginner, intermediate, advanced, unknown }

class LevelAssessmentScreen extends StatefulWidget {
  const LevelAssessmentScreen({super.key});

  @override
  State<LevelAssessmentScreen> createState() => _LevelAssessmentScreenState();
}

class _LevelAssessmentScreenState extends State<LevelAssessmentScreen> {
  EnglishLevel? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    return OnboardingLayout(
      title: 'Your English\nLevel',
      subtitle: 'This helps us personalize your experience',
      currentStep: 3,
      totalSteps: 4,
      buttonLabel: 'Continue',
      isButtonEnabled: _selectedLevel != null,
      onNext: () {
        if (_selectedLevel == EnglishLevel.unknown) {
          // TODO: navigate to the quick quiz
          // For now we go to home
          Navigator.pushNamed(context, AppRouter.home);
        } else {
          Navigator.pushNamed(context, AppRouter.home);
        }
      },

      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLevelCard(
            level: EnglishLevel.beginner,
            emoji: '🌱',
            title: 'Beginner',
            description: 'I know basic words and simple sentences',
          ),
          const SizedBox(height: 12),
          _buildLevelCard(
            level: EnglishLevel.intermediate,
            emoji: '📖',
            title: 'Intermediate',
            description: 'I can hold conversations but want to improve',
          ),
          const SizedBox(height: 12),
          _buildLevelCard(
            level: EnglishLevel.advanced,
            emoji: '🎓',
            title: 'Advanced',
            description: 'I\'m fluent and want to expand my vocabulary',
          ),
          const SizedBox(height: 12),
          _buildLevelCard(
            level: EnglishLevel.unknown,
            emoji: '🤔',
            title: 'I\'m not sure',
            description: 'Let me take a quick test to find out',
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required EnglishLevel level,
    required String emoji,
    required String title,
    required String description,
  }) {
    final isSelected = _selectedLevel == level;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = level),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
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
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.accent
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 1.0 : 0.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}