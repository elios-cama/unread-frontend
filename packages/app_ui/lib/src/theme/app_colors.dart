import 'package:flutter/material.dart';

class AppColors {
  // Dark theme colors inspired by the "untitled" music app
  static const Color background = Color(0xFF0A0A0A); // Deep black background
  static const Color surface = Color(0xFF1C1C1E); // Dark surface cards
  static const Color surfaceVariant =
      Color(0xFF2C2C2E); // Slightly lighter surface

  // Primary colors - using a subtle white/gray for minimalism
  static const Color primary = Color(0xFFFFFFFF); // Pure white for emphasis
  static const Color primaryVariant = Color(0xFFE5E5E7); // Subtle gray variant
  static const Color secondary = Color(0xFF8E8E93); // System gray

  // Text colors
  static const Color onBackground = Color(0xFFFFFFFF); // White text on dark
  static const Color onSurface = Color(0xFFE5E5E7); // Light gray text
  static const Color onPrimary = Color(0xFF000000); // Black text on white
  static const Color onSecondary = Color(0xFFFFFFFF); // White text on gray

  // Accent colors
  static const Color accent = Color(0xFF007AFF); // iOS blue for links/actions
  static const Color error = Color(0xFFFF3B30); // iOS red for errors
  static const Color warning = Color(0xFFFF9500); // iOS orange for warnings
  static const Color success = Color(0xFF34C759); // iOS green for success
  static const Color onError = Color(0xFFFFFFFF); // White text on error

  // Book cover placeholder colors (inspired by CD rainbow effect)
  static const List<Color> bookCoverGradients = [
    Color(0xFF667eea), // Purple blue
    Color(0xFFf093fb), // Pink purple
    Color(0xFF4facfe), // Blue
    Color(0xFF43e97b), // Green
    Color(0xFFfa709a), // Pink
    Color(0xFFffecd2), // Cream
    Color(0xFFfcb69f), // Peach
    Color(0xFF8360c3), // Purple
    Color(0xFF2ebf91), // Teal
    Color(0xFFfd79a8), // Rose
  ];

  // Special colors for the holographic CD effect
  static const Color holographicBase = Color(0xFFE1E1E1);
  static const Color holographicHighlight = Color(0xFFFFFFFF);
  static const List<Color> holographicSpectrum = [
    Color(0xFFFF0080), // Magenta
    Color(0xFF8000FF), // Violet
    Color(0xFF0080FF), // Blue
    Color(0xFF00FF80), // Green
    Color(0xFF80FF00), // Yellow-green
    Color(0xFFFF8000), // Orange
  ];
}
