import 'package:envied/envied.dart';
part 'staging_env.g.dart';

@Envied(path: '../../.env.staging')
abstract class StagingEnv {
  @EnviedField(varName: 'APP_NAME', defaultValue: 'Unread Staging')
  static const String appName = _StagingEnv.appName;

  @EnviedField(
    varName: 'API_BASE_URL',
    defaultValue: 'https://staging-api.unread.io',
  )
  static const String apiBaseUrl = _StagingEnv.apiBaseUrl;

  @EnviedField(
    varName: 'WEB_APP_URL',
    defaultValue: 'https://staging.unread.io',
  )
  static const String webAppUrl = _StagingEnv.webAppUrl;

  @EnviedField(
    varName: 'SUPABASE_URL',
    defaultValue: 'https://odrtvtmkapkqutgsmybf.supabase.co',
  )
  static const String supabaseUrl = _StagingEnv.supabaseUrl;

  @EnviedField(
    varName: 'SUPABASE_ANON_KEY',
    defaultValue: '',
  )
  static const String supabaseAnonKey = _StagingEnv.supabaseAnonKey;
}
