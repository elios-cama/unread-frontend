import 'staging_env.dart';
import 'production_env.dart';

enum AppFlavor { staging, production }

class AppConfig {
  static AppFlavor _currentFlavor = AppFlavor.staging;

  static AppFlavor get currentFlavor => _currentFlavor;

  static void setFlavor(AppFlavor flavor) {
    _currentFlavor = flavor;
  }

  static String get appName {
    switch (_currentFlavor) {
      case AppFlavor.staging:
        return StagingEnv.appName;
      case AppFlavor.production:
        return ProductionEnv.appName;
    }
  }

  static String get apiBaseUrl {
    switch (_currentFlavor) {
      case AppFlavor.staging:
        return StagingEnv.apiBaseUrl;
      case AppFlavor.production:
        return ProductionEnv.apiBaseUrl;
    }
  }

  static String get webAppUrl {
    switch (_currentFlavor) {
      case AppFlavor.staging:
        return StagingEnv.webAppUrl;
      case AppFlavor.production:
        return ProductionEnv.webAppUrl;
    }
  }

  static bool get isDebug => _currentFlavor == AppFlavor.staging;
  static bool get isProduction => _currentFlavor == AppFlavor.production;
}
