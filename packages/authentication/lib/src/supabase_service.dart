import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:common/common.dart';

/// Service to initialize Supabase with environment-specific configuration
class SupabaseService {
  static bool _initialized = false;

  /// Initialize Supabase with current environment configuration
  /// Call this after AppInitializer.initialize()
  static Future<void> initialize() async {
    if (_initialized) {
      debugPrint('Supabase already initialized');
      return;
    }

    // Ensure app is initialized first
    if (!AppInitializer.isInitialized) {
      throw Exception(
        'App not initialized. Call AppInitializer.initialize() first.',
      );
    }

    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        debug: AppConfig.isDebug,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
        ),
      );

      _initialized = true;
      debugPrint('Supabase initialized successfully');
      debugPrint('Supabase URL: ${AppConfig.supabaseUrl}');
    } catch (e) {
      debugPrint('Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  /// Get the current Supabase client
  static SupabaseClient get client {
    if (!_initialized) {
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return Supabase.instance.client;
  }

  /// Check if Supabase is initialized
  static bool get isInitialized => _initialized;
}
