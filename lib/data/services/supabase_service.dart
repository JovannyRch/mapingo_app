import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/env.dart';

class SupabaseService {
  static SupabaseService? _instance;
  late final SupabaseClient _client;

  SupabaseService._(this._client);

  static SupabaseClient get client {
    if (_instance == null) {
      throw StateError('SupabaseService not initialized. Call init() first.');
    }
    return _instance!._client;
  }

  static Future<SupabaseService> init() async {
    if (_instance != null) return _instance!;

    Env.validate();

    await Supabase.initialize(
      url: 'https://zbobrfeagwawjkrbtecf.supabase.co',
      anonKey: 'sb_publishable_56EooVv1rU1ouMAjHXDIwQ_fqk1pPrK',
    );

    _instance = SupabaseService._(Supabase.instance.client);
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  GoTrueClient get auth => _client.auth;
  SupabaseQueryBuilder from(String table) => _client.from(table);
  RealtimeChannel channel(String name) => _client.channel(name);
  PostgrestFilterBuilder<T> rpc<T>(String fn, {Map<String, dynamic>? params}) =>
      _client.rpc(fn, params: params);
}
