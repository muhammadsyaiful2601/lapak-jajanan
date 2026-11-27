import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/app.dart';
import 'package:lapak_jajanan/core/config/app_config.dart';
import 'package:lapak_jajanan/core/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _isReady = !AppConfig.isConfigured;
  Object? _initializationError;

  @override
  void initState() {
    super.initState();
    if (AppConfig.isConfigured) {
      unawaited(_initializeSupabase());
    }
  }

  Future<void> _initializeSupabase() async {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        publishableKey: AppConfig.apiKey,
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'Supabase initialization',
        ),
      );
      if (!mounted) return;
      setState(() => _initializationError = error);
    } finally {
      if (mounted) setState(() => _isReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationError case final error?) {
      return _StartupErrorApp(error: error);
    }
    if (!_isReady) return const _StartupLoadingApp();
    return const LapakJajananApp();
  }
}

class _StartupLoadingApp extends StatelessWidget {
  const _StartupLoadingApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Menyiapkan koneksi aplikasi...'),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: 'Lapak Jajanan — Gagal Memulai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.error,
                        size: 36,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Koneksi aplikasi gagal disiapkan',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Periksa SUPABASE_URL dan SUPABASE_PUBLISHABLE_KEY, '
                        'koneksi internet, lalu jalankan ulang aplikasi.',
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
