import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/lesson_datasource.dart';
import '../../data/models/lesson_models.dart';
import '../../data/repositories/lesson_repository.dart';
export 'lesson_engine_controller.dart';
export 'lesson_engine_state.dart';

final lessonDatasourceProvider = Provider<LessonDatasource>((ref) {
  return LessonDatasource(ref.watch(supabaseClientProvider));
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(ref.watch(lessonDatasourceProvider));
});

final unitsProvider = FutureProvider<List<UnitModel>>((ref) {
  return ref.watch(lessonRepositoryProvider).fetchUnits();
});

final lessonsProvider = FutureProvider<List<LessonModel>>((ref) {
  return ref.watch(lessonRepositoryProvider).fetchLessons();
});

final lessonsByUnitProvider = FutureProvider.family<List<LessonModel>, String>((
  ref,
  unitId,
) {
  return ref.watch(lessonRepositoryProvider).fetchLessonsByUnit(unitId);
});

final exercisesByLessonProvider =
    FutureProvider.family<List<ExerciseModel>, String>((ref, lessonId) {
      return ref
          .watch(lessonRepositoryProvider)
          .fetchExercisesByLesson(lessonId);
    });

final userLessonProgressProvider =
    FutureProvider.family<UserLessonProgressModel?, String>((
      ref,
      lessonId,
    ) async {
      final session = await ref.watch(startupAuthProvider.future);

      return ref
          .watch(lessonRepositoryProvider)
          .fetchUserLessonProgress(userId: session.user.id, lessonId: lessonId);
    });

final userProgressProvider = FutureProvider<List<UserLessonProgressModel>>((
  ref,
) async {
  final session = await ref.watch(startupAuthProvider.future);
  return ref.watch(lessonRepositoryProvider).fetchUserProgress(session.user.id);
});

final lessonProgressControllerProvider =
    AsyncNotifierProvider<LessonProgressController, void>(
      LessonProgressController.new,
    );

class LessonProgressController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<UserLessonProgressModel> saveLessonProgress(
    LessonProgressInput progress,
  ) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final session = await ref.read(startupAuthProvider.future);
      return ref
          .read(lessonRepositoryProvider)
          .saveLessonProgress(userId: session.user.id, progress: progress);
    });

    state = result.when(
      data: (_) => const AsyncData(null),
      error: AsyncError.new,
      loading: () => const AsyncLoading(),
    );

    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }

    ref.invalidate(userProgressProvider);
    ref.invalidate(userLessonProgressProvider(progress.lessonId));
    return result.value!;
  }

  Future<ExerciseAttemptModel> saveExerciseAttempt(
    ExerciseAttemptInput attempt,
  ) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final session = await ref.read(startupAuthProvider.future);
      return ref
          .read(lessonRepositoryProvider)
          .saveExerciseAttempt(userId: session.user.id, attempt: attempt);
    });

    state = result.when(
      data: (_) => const AsyncData(null),
      error: AsyncError.new,
      loading: () => const AsyncLoading(),
    );

    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }

    return result.value!;
  }

  Future<UserMistakeModel> saveMistake(String exerciseId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final session = await ref.read(startupAuthProvider.future);
      return ref
          .read(lessonRepositoryProvider)
          .saveMistake(userId: session.user.id, exerciseId: exerciseId);
    });

    state = result.when(
      data: (_) => const AsyncData(null),
      error: AsyncError.new,
      loading: () => const AsyncLoading(),
    );

    if (result.hasError) {
      Error.throwWithStackTrace(result.error!, result.stackTrace!);
    }

    return result.value!;
  }
}
