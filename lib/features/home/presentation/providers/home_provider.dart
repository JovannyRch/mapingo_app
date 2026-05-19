import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../lessons/presentation/providers/lesson_providers.dart';
import '../../data/models/home_models.dart';
import '../../data/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(lessonRepositoryProvider));
});

final homeContentProvider = FutureProvider<HomeContent>((ref) async {
  final session = await ref.watch(startupAuthProvider.future);

  return ref
      .watch(homeRepositoryProvider)
      .fetchHomeContent(userId: session.user.id, profile: session.profile);
});
