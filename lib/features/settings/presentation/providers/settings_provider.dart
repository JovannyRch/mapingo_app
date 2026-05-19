import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/models/settings_model.dart';
import '../../data/repositories/settings_repository.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

final settingsLocalDatasourceProvider = FutureProvider<SettingsLocalDatasource>(
  (ref) async {
    final preferences = await ref.watch(sharedPreferencesProvider.future);
    return SettingsLocalDatasource(preferences);
  },
);

final settingsRepositoryProvider = FutureProvider<SettingsRepository>((
  ref,
) async {
  final datasource = await ref.watch(settingsLocalDatasourceProvider.future);
  return SettingsRepository(datasource);
});

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, SettingsModel>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<SettingsModel> {
  @override
  Future<SettingsModel> build() async {
    final repository = await ref.watch(settingsRepositoryProvider.future);
    return repository.fetchSettings();
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    await _updateSettings(
      (repository) => repository.setSoundEffectsEnabled(enabled),
    );
  }

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    await _updateSettings(
      (repository) => repository.setHapticFeedbackEnabled(enabled),
    );
  }

  Future<void> resetLocalCache() async {
    await _updateSettings((repository) => repository.resetLocalCache());
  }

  Future<void> updateUsername(String username) async {
    await ref.read(startupAuthProvider.notifier).updateUsername(username);
  }

  Future<void> updateDailyGoal(int dailyGoalMinutes) async {
    await ref
        .read(startupAuthProvider.notifier)
        .updateDailyGoal(dailyGoalMinutes);
  }

  Future<void> resetGuestSession() async {
    await ref.read(startupAuthProvider.notifier).resetGuestSession();
    await resetLocalCache();
  }

  Future<void> _updateSettings(
    Future<SettingsModel> Function(SettingsRepository repository) update,
  ) async {
    final previousState = state;
    final currentSettings = state.valueOrNull ?? const SettingsModel.defaults();

    state = AsyncData(currentSettings);
    final result = await AsyncValue.guard(() async {
      final repository = await ref.read(settingsRepositoryProvider.future);
      return update(repository);
    });

    state = result;

    if (result.hasError) {
      state = previousState;
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
  }
}
