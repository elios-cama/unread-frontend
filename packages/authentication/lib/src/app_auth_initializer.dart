import 'package:flutter/foundation.dart';
import 'package:common/common.dart';
import 'supabase_service.dart';

/// Comprehensive app and authentication initializer
class AppAuthInitializer {
  /// Initialize the complete app including authentication services
  static Future<void> initialize({
    required AppFlavor flavor,
  }) async {
    try {
      debugPrint('🚀 Starting app initialization...');

      // Step 1: Initialize app configuration
      await AppInitializer.initialize(flavor: flavor);

      // Step 2: Initialize Supabase
      await SupabaseService.initialize();

      debugPrint('✅ App initialization completed successfully');
    } catch (e) {
      debugPrint('❌ App initialization failed: $e');
      rethrow;
    }
  }
}
