import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/profile_stats_model.dart';

final profileStatsProvider = FutureProvider<ProfileStatsModel>((ref) async {
  final session = await ref.watch(startupAuthProvider.future);
  return ref.watch(profileRepositoryProvider).fetchStats(session.user.id);
});

final usernameUpdateControllerProvider =
    AsyncNotifierProvider<UsernameUpdateController, void>(
      UsernameUpdateController.new,
    );

class UsernameUpdateController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateUsername(String username) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await ref.read(startupAuthProvider.notifier).updateUsername(username);
    });

    state = result;

    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }
  }
}
