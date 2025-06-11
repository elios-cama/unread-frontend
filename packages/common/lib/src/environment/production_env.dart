import 'package:envied/envied.dart';
part 'production_env.g.dart';

@Envied(path: '../../.env.production')
abstract class ProductionEnv {
  @EnviedField(varName: 'APP_NAME', defaultValue: 'Unread')
  static const String appName = _ProductionEnv.appName;

  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'https://api.unread.io')
  static const String apiBaseUrl = _ProductionEnv.apiBaseUrl;

  @EnviedField(varName: 'WEB_APP_URL', defaultValue: 'https://unread.io')
  static const String webAppUrl = _ProductionEnv.webAppUrl;

  @EnviedField(
    varName: 'SUPABASE_URL',
    defaultValue: 'https://jsxrkooqkdoiuwlzshoc.supabase.co',
  )
  static const String supabaseUrl = _ProductionEnv.supabaseUrl;

  @EnviedField(
    varName: 'SUPABASE_ANON_KEY',
    defaultValue: '',
  )
  static const String supabaseAnonKey = _ProductionEnv.supabaseAnonKey;
}
