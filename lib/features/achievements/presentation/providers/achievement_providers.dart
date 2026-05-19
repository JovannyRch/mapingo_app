import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/achievement_datasource.dart';
import '../../data/models/achievement_models.dart';
import '../../data/repositories/achievement_repository.dart';

final achievementDatasourceProvider = Provider<AchievementDatasource>((ref) {
  return AchievementDatasource(ref.watch(supabaseClientProvider));
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository(ref.watch(achievementDatasourceProvider));
});

final achievementsContentProvider = FutureProvider<AchievementsContent>((
  ref,
) async {
  final session = await ref.watch(startupAuthProvider.future);
  return ref
      .watch(achievementRepositoryProvider)
      .fetchAchievementsContent(session.user.id);
});

final achievementUnlockControllerProvider =
    AsyncNotifierProvider<AchievementUnlockController, List<AchievementModel>>(
      AchievementUnlockController.new,
    );

class AchievementUnlockController
    extends AsyncNotifier<List<AchievementModel>> {
  @override
  Future<List<AchievementModel>> build() async {
    return const [];
  }

  Future<List<AchievementModel>> checkAndUnlock() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final session = await ref.read(startupAuthProvider.future);
      return ref
          .read(achievementRepositoryProvider)
          .checkAndUnlock(session.user.id);
    });

    state = result;
    ref.invalidate(achievementsContentProvider);

    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }

    return result.value ?? const [];
  }
}
