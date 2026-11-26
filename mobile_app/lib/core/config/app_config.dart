/// Konfigurasi aplikasi yang disuntikkan lewat `--dart-define`.
///
/// Contoh:
/// ```bash
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///   --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_xxx
/// ```
class AppConfig {
  const AppConfig._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  /// Kompatibilitas dengan project Supabase lama yang masih memakai anon key.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  static String get apiKey => supabasePublishableKey.isNotEmpty
      ? supabasePublishableKey
      : supabaseAnonKey;

  /// Aplikasi boleh dijalankan tanpa kredensial untuk melihat scaffold UI.
  static bool get isConfigured =>
      supabaseUrl.startsWith('https://') && apiKey.isNotEmpty;
}
