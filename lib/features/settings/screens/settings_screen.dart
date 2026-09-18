// ============================================================
// SETTINGS SCREEN
// User preferences: theme, language, notifications, about.
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Toggle states
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Text(
                  'Settings',
                  style:
                      theme.textTheme.displayLarge?.copyWith(fontSize: 30),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // ── APPEARANCE ───────────────────────────
                    _sectionTitle('Appearance', theme),
                    _buildSettingsCard(
                      isDark: isDark,
                      children: [
                        _switchTile(
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          subtitle: 'Override system setting',
                          value: _darkModeEnabled,
                          onChanged: (val) =>
                              setState(() => _darkModeEnabled = val),
                          theme: theme,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── LANGUAGE ─────────────────────────────
                    _sectionTitle('Language', theme),
                    _buildSettingsCard(
                      isDark: isDark,
                      children: [
                        _navigationTile(
                          icon: Icons.language_outlined,
                          title: 'App Language',
                          subtitle: _selectedLanguage,
                          onTap: () => _showLanguagePicker(),
                          theme: theme,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── NOTIFICATIONS ────────────────────────
                    _sectionTitle('Notifications', theme),
                    _buildSettingsCard(
                      isDark: isDark,
                      children: [
                        _switchTile(
                          icon: Icons.notifications_outlined,
                          title: 'Reminders',
                          subtitle: 'Daily vocabulary notifications',
                          value: _notificationsEnabled,
                          onChanged: (val) =>
                              setState(() => _notificationsEnabled = val),
                          theme: theme,
                        ),
                        if (_notificationsEnabled) ...[
                          _divider(isDark),
                          _navigationTile(
                            icon: Icons.schedule_outlined,
                            title: 'Schedule',
                            subtitle: '3 reminders per day, 9AM–9PM',
                            onTap: () {},
                            theme: theme,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── ABOUT ────────────────────────────────
                    _sectionTitle('About', theme),
                    _buildSettingsCard(
                      isDark: isDark,
                      children: [
                        _navigationTile(
                          icon: Icons.info_outline,
                          title: 'Version',
                          subtitle: '1.0.0 (MVP)',
                          onTap: () {},
                          theme: theme,
                          showChevron: false,
                        ),
                        _divider(isDark),
                        _navigationTile(
                          icon: Icons.star_outline,
                          title: 'Rate the App',
                          subtitle: 'Share your feedback',
                          onTap: () {},
                          theme: theme,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  // A rounded card that groups related settings together
  Widget _buildSettingsCard({
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.white.withValues(alpha: 0.85),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(children: children),
    );
  }

  // A row with a toggle switch
  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.accent.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5))),
              ],
            ),
          ),
          Switch.adaptive(
            // .adaptive uses iOS-style switch on Apple platforms
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  // A row that navigates somewhere when tapped
  Widget _navigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    bool showChevron = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.accent.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 66),
      child: Divider(
        height: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Language',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _languageOption(ctx, 'English', '🇬🇧'),
              const SizedBox(height: 12),
              _languageOption(ctx, 'Persian', '🇮🇷'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(BuildContext ctx, String name, String flag) {
    final isSelected = _selectedLanguage == name;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedLanguage = name);
        Navigator.pop(ctx);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Text(name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.accent : null,
                )),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}