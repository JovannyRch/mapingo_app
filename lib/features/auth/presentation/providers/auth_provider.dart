import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/env.dart';
import '../../../../data/services/supabase_service.dart';
import '../../../profile/data/datasources/profile_datasource.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../profile/data/repositories/profile_repository.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  if (!Env.isConfigured || !SupabaseService.isInitialized) {
    throw StateError('Supabase is not configured for this build.');
  }

  return SupabaseService.client;
});

final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthDatasource(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authDatasourceProvider));
});

final profileDatasourceProvider = Provider<ProfileDatasource>((ref) {
  return ProfileDatasource(ref.watch(supabaseClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(profileDatasourceProvider));
});

final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final startupAuthProvider =
    AsyncNotifierProvider<StartupAuthNotifier, AuthSession>(
      StartupAuthNotifier.new,
    );

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(startupAuthProvider).valueOrNull?.user;
});

final currentProfileProvider = Provider<ProfileModel?>((ref) {
  return ref.watch(startupAuthProvider).valueOrNull?.profile;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

final isAnonymousProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider)?.isAnonymous ?? false;
});

class AuthSession {
  final User user;
  final ProfileModel profile;

  const AuthSession({required this.user, required this.profile});

  AuthSession copyWith({User? user, ProfileModel? profile}) {
    return AuthSession(
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }
}

class StartupAuthNotifier extends AsyncNotifier<AuthSession> {
  @override
  Future<AuthSession> build() {
    return _loadSession();
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadSession);
  }

  Future<void> completeOnboarding({
    required String username,
    required int dailyGoalMinutes,
  }) async {
    final session = state.valueOrNull;
    if (session == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final profile = await ref
          .read(profileRepositoryProvider)
          .saveOnboarding(
            userId: session.user.id,
            username: username,
            dailyGoalMinutes: dailyGoalMinutes,
          );

      return session.copyWith(profile: profile);
    });
  }

  Future<void> updateUsername(String username) async {
    final session = state.valueOrNull;
    if (session == null) return;

    final previousState = state;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final profile = await ref
          .read(profileRepositoryProvider)
          .updateUsername(userId: session.user.id, username: username);

      return session.copyWith(profile: profile);
    });

    state = result;

    if (result.hasError) {
      state = previousState;
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
  }

  Future<void> updateDailyGoal(int dailyGoalMinutes) async {
    final session = state.valueOrNull;
    if (session == null) return;

    final previousState = state;
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final profile = await ref
          .read(profileRepositoryProvider)
          .updateDailyGoal(
            userId: session.user.id,
            dailyGoalMinutes: dailyGoalMinutes,
          );

      return session.copyWith(profile: profile);
    });

    state = result;

    if (result.hasError) {
      state = previousState;
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
  }

  Future<void> resetGuestSession() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      return _loadSession();
    });
  }

  Future<AuthSession> _loadSession() async {
    final authRepository = ref.read(authRepositoryProvider);
    final profileRepository = ref.read(profileRepositoryProvider);

    final user = await authRepository.getOrCreateAnonymousUser();
    final profile = await profileRepository.getOrCreateProfile(user.id);

    return AuthSession(user: user, profile: profile);
  }
}
