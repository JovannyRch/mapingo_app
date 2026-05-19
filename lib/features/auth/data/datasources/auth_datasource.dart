import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDatasource {
  final SupabaseClient _client;

  const AuthDatasource(this._client);

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<User> signInAnonymously() async {
    final AuthResponse response;
    try {
      response = await _client.auth.signInAnonymously();
    } on AuthException catch (error) {
      if (error.code == 'anonymous_provider_disabled') {
        throw const AuthException(
          'Anonymous sign-ins are disabled in Supabase. Enable Anonymous sign-ins in Authentication > Providers before starting Mapingo.',
          code: 'anonymous_provider_disabled',
        );
      }
      rethrow;
    }

    final user = response.user;

    if (user == null) {
      throw const AuthException('Anonymous sign-in did not return a user.');
    }

    return user;
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
