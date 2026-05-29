import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/components/components.dart';
import '../../../map_explorer/presentation/providers/map_explorer_provider.dart';
import '../../../map_explorer/presentation/widgets/mexico_map_view.dart';
import '../../data/models/lesson_models.dart';
import '../providers/lesson_engine_controller.dart';
import '../providers/lesson_engine_state.dart';
import '../providers/lesson_selection_provider.dart';
import '../providers/match_pairs_provider.dart';

class LessonScreen extends ConsumerWidget {
  final String lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineState = ref.watch(lessonEngineProvider(lessonId));

    return Scaffold(
      body: engineState.when(
        loading: () => const LoadingView(message: 'Loading lesson...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not load lesson',
          message: error.toString(),
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(lessonEngineProvider(lessonId)),
        ),
        data: (state) {
          if (state.status == LessonEngineStatus.empty) {
            return const EmptyStateView(
              icon: Icons.quiz_rounded,
              title: 'No exercises yet',
              message: 'This lesson does not have practice questions yet.',
            );
          }

          return _LessonContent(lessonId: lessonId, state: state);
        },
      ),
    );
  }
}

class _LessonContent extends ConsumerWidget {
  final String lessonId;
  final LessonEngineState state;

  const _LessonContent({required this.lessonId, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = state.currentExercise;
    final selection = ref.watch(lessonSelectionProvider(lessonId));
    final isBusy =
        state.status == LessonEngineStatus.submittingAnswer ||
        state.status == LessonEngineStatus.completing;

    if (exercise == null) {
      return const EmptyStateView(
        icon: Icons.check_circle_rounded,
        title: 'Lesson complete',
        message: 'You answered every question.',
      );
    }

    return SafeArea(
      child: Column(
        children: [
          _LessonTopBar(state: state),
          Expanded(
            child: SingleChildScrollView(
              padding: MapingoSpacing.screenPadding,
              child: AnimatedSwitcher(
                duration: MapingoTheme.durationNormal,
                child: Column(
                  key: ValueKey(exercise.id),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _QuestionCard(exercise: exercise),
                    const SizedBox(height: MapingoSpacing.xl),
                    _ExerciseRenderer(
                      lessonId: lessonId,
                      exercise: exercise,
                      selection: selection,
                      isAnswered: state.currentExerciseAnswered,
                      result: state.lastAnswerResult,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _FeedbackPanel(result: state.lastAnswerResult),
          _LessonActionBar(
            lessonId: lessonId,
            state: state,
            selectedAnswer: selection.answerFor(exercise),
            isBusy: isBusy,
          ),
        ],
      ),
    );
  }
}

class _LessonTopBar extends StatelessWidget {
  final LessonEngineState state;

  const _LessonTopBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final answeredProgress = state.currentExerciseAnswered
        ? state.currentExerciseIndex + 1
        : state.currentExerciseIndex;
    final progress = state.totalExercises == 0
        ? 0.0
        : answeredProgress / state.totalExercises;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        MapingoSpacing.base,
        MapingoSpacing.base,
        MapingoSpacing.base,
        MapingoSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close_rounded),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: MapingoTheme.borderRadiusFull,
              child: LinearProgressIndicator(
                minHeight: 12,
                value: progress.clamp(0.0, 1.0),
                backgroundColor: MapingoColors.grey200,
                valueColor: const AlwaysStoppedAnimation(MapingoColors.primary),
              ),
            ),
          ),
          const SizedBox(width: MapingoSpacing.md),
          Text(
            '${state.currentExerciseIndex + 1}/${state.totalExercises}',
            style: MapingoTypography.labelLarge.copyWith(
              color: MapingoColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final ExerciseModel exercise;

  const _QuestionCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      backgroundColor: MapingoColors.white,
      boxShadow: MapingoTheme.shadowMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: MapingoColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconFor(exercise.exerciseType),
                  color: MapingoColors.primary,
                ),
              ),
              const SizedBox(width: MapingoSpacing.md),
              Expanded(
                child: Text(
                  _labelFor(exercise.exerciseType),
                  style: MapingoTypography.labelLarge.copyWith(
                    color: MapingoColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MapingoSpacing.lg),
          Text(
            exercise.question,
            style: MapingoTypography.displaySmall.copyWith(
              color: MapingoColors.grey900,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoiceState:
        return Icons.flag_rounded;
      case ExerciseType.multipleChoiceCapital:
        return Icons.location_city_rounded;
      case ExerciseType.trueFalse:
        return Icons.rule_rounded;
      case ExerciseType.mapTap:
        return Icons.map_rounded;
      case ExerciseType.matchPairs:
        return Icons.compare_arrows_rounded;
      case ExerciseType.silhouette:
      case ExerciseType.unknown:
        return Icons.quiz_rounded;
    }
  }

  String _labelFor(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoiceState:
        return 'Find the state';
      case ExerciseType.multipleChoiceCapital:
        return 'Choose the capital';
      case ExerciseType.trueFalse:
        return 'True or false';
      case ExerciseType.mapTap:
        return 'Map practice';
      case ExerciseType.matchPairs:
        return 'Match pairs';
      case ExerciseType.silhouette:
      case ExerciseType.unknown:
        return 'Practice';
    }
  }
}

class _ExerciseRenderer extends ConsumerWidget {
  final String lessonId;
  final ExerciseModel exercise;
  final LessonSelectionState selection;
  final bool isAnswered;
  final LessonAnswerResult? result;

  const _ExerciseRenderer({
    required this.lessonId,
    required this.exercise,
    required this.selection,
    required this.isAnswered,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (exercise.exerciseType) {
      case ExerciseType.multipleChoiceState:
      case ExerciseType.multipleChoiceCapital:
        return _OptionList(
          lessonId: lessonId,
          exercise: exercise,
          options: exercise.options,
          selectedValue: selection.selectedValue,
          isAnswered: isAnswered,
          result: result,
        );
      case ExerciseType.trueFalse:
        return _OptionList(
          lessonId: lessonId,
          exercise: exercise,
          options: const ['true', 'false'],
          selectedValue: selection.selectedValue,
          isAnswered: isAnswered,
          result: result,
        );
      case ExerciseType.mapTap:
        return _MapTapExercise(
          lessonId: lessonId,
          exercise: exercise,
          selectedValue: selection.selectedValue,
          isAnswered: isAnswered,
          result: result,
        );
      case ExerciseType.matchPairs:
        return _MatchPairsExercise(
          lessonId: lessonId,
          exercise: exercise,
          isAnswered: isAnswered,
        );
      case ExerciseType.silhouette:
      case ExerciseType.unknown:
        return const EmptyStateView(
          icon: Icons.extension_off_rounded,
          title: 'Exercise not supported',
          message: 'This exercise type is not available yet.',
        );
    }
  }
}

class _OptionList extends ConsumerWidget {
  final String lessonId;
  final ExerciseModel exercise;
  final List<String> options;
  final String? selectedValue;
  final bool isAnswered;
  final LessonAnswerResult? result;

  const _OptionList({
    required this.lessonId,
    required this.exercise,
    required this.options,
    required this.selectedValue,
    required this.isAnswered,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (final option in options) ...[
          AnswerOptionCard(
            text: _displayOption(option),
            icon: Icons.touch_app_rounded,
            state: _optionState(option),
            isEnabled: !isAnswered,
            onTap: () => ref
                .read(lessonSelectionProvider(lessonId).notifier)
                .selectValue(option),
          ),
          const SizedBox(height: MapingoSpacing.md),
        ],
      ],
    );
  }

  AnswerOptionState _optionState(String option) {
    if (!isAnswered) {
      return option == selectedValue
          ? AnswerOptionState.selected
          : AnswerOptionState.normal;
    }

    if (_same(option, exercise.correctAnswer)) return AnswerOptionState.correct;
    if (_same(option, selectedValue) && result?.isCorrect == false) {
      return AnswerOptionState.incorrect;
    }
    return AnswerOptionState.normal;
  }

  String _displayOption(String value) {
    if (value == 'true') return 'True';
    if (value == 'false') return 'False';
    return value;
  }
}

class _MapTapExercise extends ConsumerWidget {
  final String lessonId;
  final ExerciseModel exercise;
  final String? selectedValue;
  final bool isAnswered;
  final LessonAnswerResult? result;

  const _MapTapExercise({
    required this.lessonId,
    required this.exercise,
    required this.selectedValue,
    required this.isAnswered,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapContent = ref.watch(mapExplorerContentProvider);
    final wrongMapKey = result?.isCorrect == false ? selectedValue : null;

    return mapContent.when(
      loading: () =>
          const LoadingView(message: 'Loading map...', showLogo: false),
      error: (error, stackTrace) => ErrorView(
        title: 'Could not load map',
        message: error.toString(),
        actionLabel: 'Try again',
        onAction: () => ref.invalidate(mapExplorerContentProvider),
      ),
      data: (content) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 420,
            child: MexicoMapView(
              states: content.states,
              selectedMapKey: selectedValue,
              correctMapKey: exercise.correctAnswer,
              wrongMapKey: wrongMapKey,
              isFeedbackVisible: isAnswered,
              onStateTap: (state) {
                if (isAnswered) return;
                ref
                    .read(lessonSelectionProvider(lessonId).notifier)
                    .selectValue(state.mapKey);
              },
            ),
          ),
          const SizedBox(height: MapingoSpacing.md),
          Text(
            isAnswered
                ? result?.isCorrect == true
                      ? 'Correct state selected.'
                      : 'The correct state is highlighted in green.'
                : 'Tap the state on the map.',
            style: MapingoTypography.bodyMedium.copyWith(
              color: MapingoColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MatchPairsExercise extends ConsumerWidget {
  final String lessonId;
  final ExerciseModel exercise;
  final bool isAnswered;

  const _MatchPairsExercise({
    required this.lessonId,
    required this.exercise,
    required this.isAnswered,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchKey = MatchPairsKey(lessonId: lessonId, exerciseId: exercise.id);
    final matchState = ref.watch(matchPairsProvider(matchKey));
    final controller = ref.read(matchPairsProvider(matchKey).notifier);
    final rightOptions = exercise.metadata.pairs
        .map((pair) => pair.right)
        .toList();

    if (matchState.allPairsMatched(exercise) &&
        !matchState.submittedToEngine &&
        !isAnswered) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.markSubmittedToEngine();
        await ref
            .read(lessonEngineProvider(lessonId).notifier)
            .submitAnswer(LessonAnswer.pairs(matchState.matchedPairs));
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _MatchColumn(
                title: 'States',
                children: [
                  for (final pair in exercise.metadata.pairs)
                    _MatchCard(
                      text: pair.left,
                      icon: Icons.flag_rounded,
                      state: _leftCardState(pair.left, matchState),
                      isEnabled:
                          !isAnswered && !matchState.isMatchedLeft(pair.left),
                      onTap: () => controller.selectLeft(pair.left),
                    ),
                ],
              ),
            ),
            const SizedBox(width: MapingoSpacing.md),
            Expanded(
              child: _MatchColumn(
                title: 'Capitals',
                children: [
                  for (final right in rightOptions)
                    _MatchCard(
                      text: right,
                      icon: Icons.location_city_rounded,
                      state: _rightCardState(right, matchState),
                      isEnabled:
                          !isAnswered &&
                          matchState.selectedLeft != null &&
                          !matchState.isMatchedRight(right),
                      onTap: () => controller.selectRight(
                        exercise: exercise,
                        right: right,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (matchState.wrongLeft != null && matchState.wrongRight != null) ...[
          const SizedBox(height: MapingoSpacing.base),
          MapingoCard(
            backgroundColor: MapingoColors.errorLight,
            boxShadow: [],
            border: Border.all(color: MapingoColors.error),
            child: Row(
              children: [
                const Icon(Icons.refresh_rounded, color: MapingoColors.error),
                const SizedBox(width: MapingoSpacing.md),
                Expanded(
                  child: Text(
                    'Not that pair. Try matching ${matchState.wrongLeft} again.',
                    style: MapingoTypography.bodyMedium.copyWith(
                      color: MapingoColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (matchState.allPairsMatched(exercise) && !isAnswered) ...[
          const SizedBox(height: MapingoSpacing.base),
          const LoadingView(message: 'Checking pairs...', showLogo: false),
        ],
      ],
    );
  }

  AnswerOptionState _leftCardState(String left, MatchPairsState state) {
    if (state.isMatchedLeft(left)) return AnswerOptionState.correct;
    if (state.selectedLeft == left) return AnswerOptionState.selected;
    return AnswerOptionState.normal;
  }

  AnswerOptionState _rightCardState(String right, MatchPairsState state) {
    if (state.isMatchedRight(right)) return AnswerOptionState.correct;
    if (state.wrongRight == right) return AnswerOptionState.incorrect;
    return AnswerOptionState.normal;
  }
}

class _MatchColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MatchColumn({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: MapingoTypography.labelLarge.copyWith(
            color: MapingoColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: MapingoSpacing.sm),
        ...children,
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final AnswerOptionState state;
  final bool isEnabled;
  final VoidCallback onTap;

  const _MatchCard({
    required this.text,
    required this.icon,
    required this.state,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MapingoSpacing.sm),
      child: AnswerOptionCard(
        text: text,
        icon: icon,
        state: state,
        isEnabled: isEnabled,
        onTap: onTap,
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  final LessonAnswerResult? result;

  const _FeedbackPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final answerResult = result;
    if (answerResult == null) return const SizedBox.shrink();

    final isCorrect = answerResult.isCorrect;

    return AnimatedContainer(
      duration: MapingoTheme.durationNormal,
      width: double.infinity,
      padding: MapingoSpacing.paddingBase,
      decoration: BoxDecoration(
        color: isCorrect
            ? MapingoColors.successLight
            : MapingoColors.errorLight,
        border: Border(
          top: BorderSide(
            color: isCorrect ? MapingoColors.success : MapingoColors.error,
            width: 2,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isCorrect ? MapingoColors.success : MapingoColors.error,
            size: 32,
          ),
          const SizedBox(width: MapingoSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCorrect ? 'Nice work!' : 'Not quite',
                  style: MapingoTypography.headlineSmall.copyWith(
                    color: isCorrect
                        ? MapingoColors.success
                        : MapingoColors.error,
                  ),
                ),
                if (answerResult.explanation != null) ...[
                  const SizedBox(height: MapingoSpacing.xs),
                  Text(
                    answerResult.explanation!,
                    style: MapingoTypography.bodyMedium.copyWith(
                      color: MapingoColors.grey700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonActionBar extends ConsumerWidget {
  final String lessonId;
  final LessonEngineState state;
  final LessonAnswer? selectedAnswer;
  final bool isBusy;

  const _LessonActionBar({
    required this.lessonId,
    required this.state,
    required this.selectedAnswer,
    required this.isBusy,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnswered = state.currentExerciseAnswered;
    final canCheck = selectedAnswer != null && !isBusy;

    return Container(
      padding: MapingoSpacing.paddingBase,
      decoration: const BoxDecoration(
        color: MapingoColors.white,
        border: Border(top: BorderSide(color: MapingoColors.grey200)),
      ),
      child: PrimaryButton(
        label: isAnswered
            ? state.isLastExercise
                  ? 'See results'
                  : 'Continue'
            : 'Check',
        icon: isAnswered ? Icons.arrow_forward_rounded : Icons.check_rounded,
        isLoading: isBusy,
        onPressed: isAnswered
            ? () => _continue(context, ref)
            : canCheck
            ? () => _check(ref)
            : null,
      ),
    );
  }

  Future<void> _check(WidgetRef ref) async {
    final answer = selectedAnswer;
    if (answer == null) return;

    await ref
        .read(lessonEngineProvider(lessonId).notifier)
        .submitAnswer(answer);
  }

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(lessonEngineProvider(lessonId).notifier);
    final currentExercise = state.currentExercise;

    if (state.isLastExercise) {
      await controller.completeLesson();
      if (context.mounted) {
        context.pushReplacementNamed(
          AppRouteNames.lessonResult,
          pathParameters: {'id': lessonId},
        );
      }
      return;
    }

    if (currentExercise?.exerciseType == ExerciseType.matchPairs) {
      ref
          .read(
            matchPairsProvider(
              MatchPairsKey(
                lessonId: lessonId,
                exerciseId: currentExercise!.id,
              ),
            ).notifier,
          )
          .reset();
    }
    controller.goToNextExercise();
    ref.read(lessonSelectionProvider(lessonId).notifier).reset();
  }
}

bool _same(String? a, String? b) {
  return (a ?? '').trim().toLowerCase() == (b ?? '').trim().toLowerCase();
}
