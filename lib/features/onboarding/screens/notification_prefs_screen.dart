import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/app_router.dart';
import '../../../shared/widgets/onboarding_layout.dart';

class NotificationPrefsScreen extends StatefulWidget {
  const NotificationPrefsScreen({super.key});

  @override
  State<NotificationPrefsScreen> createState() =>
      _NotificationPrefsScreenState();
}

class _NotificationPrefsScreenState extends State<NotificationPrefsScreen> {
  // How many notifications per day (starts at 3)
  int _notificationsPerDay = 3;

  // Start and end hours for notification window
  // (default: 9am to 9pm)
  double _startHour = 9;
  double _endHour = 21;

  // Converts a double hour (e.g. 9.0) to a readable string ("9:00 AM")
  String _formatHour(double hour) {
    final h = hour.toInt();
    final period = h >= 12 ? 'PM' : 'AM';
    final displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$displayHour:00 $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OnboardingLayout(
      title: 'Notification\nSettings',
      subtitle: 'When should we send you vocabulary reminders?',
      currentStep: 2,
      totalSteps: 4,
      buttonLabel: 'Continue',
      onNext: () {
        Navigator.pushNamed(context, AppRouter.levelAssessment);
      },

      content: SingleChildScrollView(
        // SingleChildScrollView makes content scrollable if it
        // doesn't fit on screen (important for smaller devices)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HOW MANY PER DAY ───────────────────────────────
            _buildSectionTitle('Reminders per day', theme),
            const SizedBox(height: 16),
            _buildCountSelector(theme),

            const SizedBox(height: 32),

            // ── TIME WINDOW ────────────────────────────────────
            _buildSectionTitle('Active hours', theme),
            const SizedBox(height: 8),
            Text(
              '${_formatHour(_startHour)} → ${_formatHour(_endHour)}',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),
            _buildTimeSliders(theme),

            const SizedBox(height: 32),

            // ── PREVIEW ────────────────────────────────────────
            _buildPreviewCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
    );
  }

  // The +/- counter for number of notifications
  Widget _buildCountSelector(ThemeData theme) {
    return Row(
      children: [
        // Minus button
        _buildCountButton(
          icon: Icons.remove,
          onTap: () {
            if (_notificationsPerDay > 1) {
              setState(() => _notificationsPerDay--);
            }
          },
        ),

        // The count display
        Expanded(
          child: Center(
            child: Text(
              '$_notificationsPerDay',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
        ),

        // Plus button
        _buildCountButton(
          icon: Icons.add,
          onTap: () {
            if (_notificationsPerDay < 10) {
              setState(() => _notificationsPerDay++);
            }
          },
        ),
      ],
    );
  }

  Widget _buildCountButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: 0.15),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(icon, color: AppColors.accent),
      ),
    );
  }

  // The two sliders for start/end hour
  Widget _buildTimeSliders(ThemeData theme) {
    return Column(
      children: [
        // Start time slider
        Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                'From',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              // Slider lets the user drag to pick a value
              child: Slider(
                value: _startHour,
                min: 6,   // Earliest: 6am
                max: 20,  // Latest start: 8pm
                divisions: 14,
                activeColor: AppColors.accent,
                onChanged: (value) {
                  setState(() {
                    _startHour = value;
                    // Make sure start doesn't go past end
                    if (_startHour >= _endHour) {
                      _endHour = _startHour + 1;
                    }
                  });
                },
              ),
            ),
          ],
        ),

        // End time slider
        Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                'Until',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Slider(
                value: _endHour,
                min: 7,
                max: 23,  // Latest: 11pm
                divisions: 16,
                activeColor: AppColors.accent,
                onChanged: (value) {
                  setState(() {
                    _endHour = value;
                    if (_endHour <= _startHour) {
                      _startHour = _endHour - 1;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // A summary card showing what the user selected
  Widget _buildPreviewCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.accent.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 Your schedule',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_notificationsPerDay reminder${_notificationsPerDay == 1 ? '' : 's'} per day\n'
            'Between ${_formatHour(_startHour)} and ${_formatHour(_endHour)}',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}