// ============================================================
// GLASS CARD WIDGET
// A reusable frosted-glass card used throughout the app.
// Any screen can use this by importing this file.
// ============================================================

import 'dart:ui'; // needed for ImageFilter (the blur effect)
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  // These are the widget's PARAMETERS — values you pass in
  // when using the widget, like arguments to a function.

  final Widget child;        // What goes inside the card
  final double? width;       // Optional width
  final double? height;      // Optional height
  final EdgeInsets? padding; // Optional inner spacing
  final double borderRadius; // How rounded the corners are

  const GlassCard({
    super.key,
    required this.child,     // 'required' means you MUST provide this
    this.width,              // Optional — can be null
    this.height,
    this.padding,
    this.borderRadius = 24,  // Default value if not provided
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      // ClipRRect clips its child to rounded corners.
      // Without this, the blur effect would bleed outside the card.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),

        // BackdropFilter applies a filter to everything BEHIND
        // the widget — creating the frosted glass blur effect.
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}