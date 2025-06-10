import 'package:flutter/foundation.dart';
import 'environment/app_config.dart';

/// Centralized app initialization service
class AppInitializer {
  static bool _initialized = false;

  /// Initialize the app with the specified flavor
  /// This should be called once at app startup
  static Future<void> initialize({
    required AppFlavor flavor,
  }) async {
    if (_initialized) {
      debugPrint('App already initialized');
      return;
    }

    try {
      // Set app flavor
      AppConfig.setFlavor(flavor);
      debugPrint('App flavor set to: $flavor');
      debugPrint('API Base URL: ${AppConfig.apiBaseUrl}');
      debugPrint('Debug mode: ${AppConfig.isDebug}');

      _initialized = true;
      debugPrint('App initialization completed successfully');
    } catch (e) {
      debugPrint('Failed to initialize app: $e');
      rethrow;
    }
  }

  /// Check if the app is initialized
  static bool get isInitialized => _initialized;
}
