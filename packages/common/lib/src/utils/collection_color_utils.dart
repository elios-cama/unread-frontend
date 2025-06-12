import 'package:flutter/material.dart';

enum CollectionColor {
  blue,
  green,
  purple,
  orange,
  red,
  pink,
  teal,
  indigo,
  yellow,
  emerald,
  rose,
  cyan,
}

class CollectionColorUtils {
  static const Map<CollectionColor, List<Color>> _gradientMap = {
    CollectionColor.blue: [
      Color(0xFF93C5FD), // blue-300
      Color(0xFF6366F1), // indigo-500 (blue to indigo)
    ],
    CollectionColor.green: [
      Color(0xFF86EFAC), // green-300
      Color(0xFF14B8A6), // teal-500 (green to teal)
    ],
    CollectionColor.purple: [
      Color(0xFFC4B5FD), // violet-300
      Color(0xFFEC4899), // pink-500 (purple to pink)
    ],
    CollectionColor.orange: [
      Color(0xFFFDBA74), // orange-300
      Color(0xFFEF4444), // red-500 (orange to red)
    ],
    CollectionColor.red: [
      Color(0xFFFCA5A5), // red-300
      Color(0xFFEC4899), // pink-500 (red to pink)
    ],
    CollectionColor.pink: [
      Color(0xFFF9A8D4), // pink-300
      Color(0xFF8B5CF6), // violet-500 (pink to purple)
    ],
    CollectionColor.teal: [
      Color(0xFF5EEAD4), // teal-300
      Color(0xFF3B82F6), // blue-500 (teal to blue)
    ],
    CollectionColor.indigo: [
      Color(0xFFA5B4FC), // indigo-300
      Color(0xFF8B5CF6), // violet-500 (indigo to purple)
    ],
    CollectionColor.yellow: [
      Color(0xFFFDE68A), // yellow-300
      Color(0xFFF97316), // orange-500 (yellow to orange)
    ],
    CollectionColor.emerald: [
      Color(0xFF6EE7B7), // emerald-300
      Color(0xFF06B6D4), // cyan-500 (emerald to cyan)
    ],
    CollectionColor.rose: [
      Color(0xFFFDA4AF), // rose-300
      Color(0xFFF97316), // orange-500 (rose to orange)
    ],
    CollectionColor.cyan: [
      Color(0xFF67E8F9), // cyan-300
      Color(0xFF10B981), // emerald-500 (cyan to emerald)
    ],
  };

  /// Creates a linear gradient for the given collection color
  /// Goes from top-left to bottom-right by default
  static LinearGradient createGradient(
    CollectionColor color, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    final colors = _gradientMap[color] ?? _gradientMap[CollectionColor.blue]!;

    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }

  /// Gets the color list for creating custom gradients
  static List<Color> getColors(CollectionColor color) {
    return _gradientMap[color] ?? _gradientMap[CollectionColor.blue]!;
  }

  /// Parses a string to CollectionColor enum
  static CollectionColor? fromString(String? colorString) {
    if (colorString == null) return null;

    try {
      return CollectionColor.values.firstWhere(
        (color) => color.name.toLowerCase() == colorString.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Converts CollectionColor enum to string for API serialization
  static String toApiString(CollectionColor color) {
    return color.name.toUpperCase();
  }

  /// Gets a random collection color
  static CollectionColor getRandomColor() {
    final colors = CollectionColor.values;
    final index = DateTime.now().millisecondsSinceEpoch % colors.length;
    return colors[index];
  }

  /// Gets the primary color (first color in gradient) for the collection color
  static Color getPrimaryColor(CollectionColor color) {
    final colors = _gradientMap[color] ?? _gradientMap[CollectionColor.blue]!;
    return colors.first;
  }

  /// Gets the secondary color (second color in gradient) for the collection color
  static Color getSecondaryColor(CollectionColor color) {
    final colors = _gradientMap[color] ?? _gradientMap[CollectionColor.blue]!;
    return colors.last;
  }
}
