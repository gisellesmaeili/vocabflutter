import 'package:flutter/material.dart';

// ============================================================
// APP COLORS
// These are the raw color values we use throughout the app.
// ============================================================
class AppColors {
  // Private constructor — prevents anyone from creating an
  // instance of this class. It's just a holder for constants.
  AppColors._();

  // --- Accent / Brand Color ---
  // This is the main color of your app — used for buttons,
  // highlights, active icons, etc.
  static const Color accent = Color(0xFF5E7CF6); // A soft indigo-blue

  // --- Light Mode Colors ---
  static const Color lightBackground = Color(0xFFF2F2F7); // iOS-style light gray
  static const Color lightSurface = Color(0xFFFFFFFF);    // Pure white for cards
  static const Color lightText = Color(0xFF1C1C1E);       // Near-black for text
  static const Color lightSubtext = Color(0xFF8E8E93);    // Gray for secondary text

  // --- Dark Mode Colors ---
  static const Color darkBackground = Color(0xFF000000);  // True black (OLED-friendly)
  static const Color darkSurface = Color(0xFF1C1C1E);     // Dark gray for cards
  static const Color darkText = Color(0xFFFFFFFF);        // White for text
  static const Color darkSubtext = Color(0xFF8E8E93);     // Same gray works in dark too

  // --- Glassmorphism Colors ---
  // These are semi-transparent whites/blacks used for the
  // frosted glass effect your design spec calls for.
  static const Color glassLight = Color(0x80FFFFFF); // 50% transparent white
  static const Color glassDark = Color(0x401C1C1E);  // 25% transparent dark
}

// ============================================================
// APP TEXT STYLES
// Define font sizes and weights used across the app.
// ============================================================
class AppTextStyles {
  AppTextStyles._();

  // Large title — used for screen headings
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.4,
  );

  // Section title — used for card titles, section headers
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // Body text — used for regular content
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5, // line height — makes text more readable
  );

  // Caption — small text under images, hints, labels
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
}

// ============================================================
// APP THEME
// This is the main theme class. It produces a ThemeData object
// for both light and dark modes that Flutter uses everywhere.
// ============================================================
class AppTheme {
  AppTheme._();

  // Shared border radius — used for cards, buttons, containers
  static const double borderRadius = 24.0;

  // ---- LIGHT THEME ----
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Seeds the entire color scheme from our accent color
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
        surface: AppColors.lightSurface,
      ),

      scaffoldBackgroundColor: AppColors.lightBackground,

      // Card theme — how cards look by default
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),

      // Elevated button theme — your main call-to-action buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56), // full width, 56px tall
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      ),

      // AppBar theme — the top bar on screens
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.largeTitle,
        titleLarge: AppTextStyles.title,
        bodyMedium: AppTextStyles.body,
        labelSmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
      ),
    );
  }

  // ---- DARK THEME ----
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
        surface: AppColors.darkSurface,
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title,
      ),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.largeTitle,
        titleLarge: AppTextStyles.title,
        bodyMedium: AppTextStyles.body,
        labelSmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
      ),
    );
  }
}