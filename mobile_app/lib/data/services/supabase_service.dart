import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapak_jajanan/core/config/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Satu-satunya akses ke Supabase dari aplikasi Flutter.
/// Kredensial dibaca dari `--dart-define`, bukan hardcode.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  if (!AppConfig.isConfigured) {
    throw StateError(
      'Supabase belum dikonfigurasi. Jalankan flutter run dengan '
      '--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
    );
  }
  return Supabase.instance.client;
});

/// Helper untuk modul minggu berikutnya (pesanan realtime, laporan, dll).
class SupabaseService {
  const SupabaseService(this._client);

  final SupabaseClient _client;

  /// Stream pesanan untuk halaman admin (FR-A06, FR-P08).
  Stream<List<Map<String, dynamic>>> watchOrders() {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  /// Rekap transaksi untuk laporan owner (FR-O04).
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    return _client.from('orders').select();
  }
}
