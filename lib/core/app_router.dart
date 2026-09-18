// ============================================================
// APP ROUTER
// This file defines all the "addresses" (routes) in your app.
// Instead of writing screen names as raw strings everywhere
// (which is error-prone), we define them as constants here.
// ============================================================

import 'package:flutter/material.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/onboarding/screens/language_selection_screen.dart';
import '../features/onboarding/screens/notification_prefs_screen.dart';
import '../features/onboarding/screens/level_assessment_screen.dart';
import '../features/home/screens/home_screen.dart';

class AppRouter {
  AppRouter._();

  // These are the route names — like URL paths in a website.
  // The '/' is always the first screen (home/root).
  static const String welcome = '/';
  static const String languageSelection = '/language-selection';
  static const String notificationPrefs = '/notification-prefs';
  static const String levelAssessment = '/level-assessment';
  static const String home = '/home';

  // This method is called by MaterialApp to build the correct
  // screen when a route name is requested.
  // 'settings.name' is the route name being requested.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _slideRoute(const WelcomeScreen());
      case languageSelection:
        return _slideRoute(const LanguageSelectionScreen());
      case notificationPrefs:
        return _slideRoute(const NotificationPrefsScreen());
      case levelAssessment:
        return _slideRoute(const LevelAssessmentScreen());
      case home:
        return _slideRoute(const HomeScreen());
      default:
        // If an unknown route is requested, show an error screen.
        return _slideRoute(
          const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  // This creates a slide animation when navigating between screens.
  // Instead of the default fade, screens will slide in from the right.
  // PageRouteBuilder lets us build a custom transition.
  static PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,

      // This defines the animation.
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // The screen slides in from the right (x: 1.0 = off-screen right)
        const begin = Offset(1.0, 0.0);
        // It ends at its normal position (x: 0 = on screen)
        const end = Offset.zero;

        // A curved animation makes the movement feel natural,
        // not robotic. easeInOut starts slow, speeds up, slows down.
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },

      // How long the animation takes
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}