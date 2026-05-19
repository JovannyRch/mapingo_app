import 'package:flutter/foundation.dart';

abstract final class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://zbobrfeagwawjkrbtecf.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_56EooVv1rU1ouMAjHXDIwQ_fqk1pPrK',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static void validate() {
    if (!isConfigured) {
      debugPrint(
        'WARNING: Supabase credentials not configured. '
        'Run with --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx',
      );
    }
  }
}
