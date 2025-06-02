enum AppFlavor { staging, production }

abstract interface class AppEnv {
  AppFlavor get flavor;
  String get appName;
  String get apiBaseUrl;
  String get webAppUrl;
  bool get isDebug;
}

class AppEnvironment {
  static AppEnv? _current;

  static AppEnv get current {
    if (_current == null) {
      throw Exception(
        'AppEnvironment not initialized. Call AppEnvironment.init() first.',
      );
    }
    return _current!;
  }

  static void init(AppEnv env) {
    _current = env;
  }
}
