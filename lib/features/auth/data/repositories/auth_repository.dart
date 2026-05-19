import 'package:supabase_flutter/supabase_flutter.dart';

import '../datasources/auth_datasource.dart';

class AuthRepository {
  final AuthDatasource _datasource;

  const AuthRepository(this._datasource);

  User? get currentUser => _datasource.currentUser;

  Stream<AuthState> get authStateChanges => _datasource.authStateChanges;

  Future<User> getOrCreateAnonymousUser() async {
    final existingUser = currentUser;
    if (existingUser != null) return existingUser;

    return _datasource.signInAnonymously();
  }

  Future<void> signOut() {
    return _datasource.signOut();
  }
}
