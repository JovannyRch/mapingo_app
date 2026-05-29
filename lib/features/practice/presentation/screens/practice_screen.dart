import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/components/components.dart';
import '../../../lessons/data/models/lesson_models.dart';
import '../../../lessons/presentation/providers/lesson_engine_state.dart';
import '../../../lessons/presentation/providers/lesson_selection_provider.dart';
import '../../../map_explorer/presentation/providers/map_explorer_provider.dart';
import '../../../map_explorer/presentation/widgets/mexico_map_view.dart';
import '../../data/models/practice_models.dart';
import '../providers/practice_provider.dart';

const _practiceSelectionKey = 'practice_session';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final practiceState = ref.watch(practiceControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.practice)),
      body: practiceState.when(
        loading: () => LoadingView(message: l10n.preparingPractice),
        error: (error, stackTrace) => ErrorView(
          title: l10n.couldNotLoadPractice,
          message: error.toString(),
          actionLabel: l10n.tryAgain,
          onAction: () => ref.invalidate(practiceControllerProvider),
        ),
        data: (state) => _PracticeBody(state: state),
      ),
    );
  }
}

class _PracticeBody extends ConsumerWidget {
  final PracticeSessionState state;

  const _PracticeBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    switch (state.status) {
      case PracticeSessionStatus.choosingMode:
        return const _ModePicker();
      case PracticeSessionStatus.loading:
        return LoadingView(message: l10n.preparingPractice);
      case PracticeSessionStatus.empty:
        return EmptyStateView(
          icon: Icons.task_alt_rounded,
          title: state.mode == PracticeMode.mistakes
              ? l10n.noMistakesToReview
              : l10n.noPracticeYet2,
          message: state.mode == PracticeMode.mistakes
              ? l10n.missedExercisesWillAppear
              : l10n.practiceQuestionsWillAppear,
          actionLabel: l10n.chooseAnotherMode,
          onAction: () => ref.read(practiceControllerProvider.notifier).reset(),
        );
      case PracticeSessionStatus.completed:
        return _PracticeComplete(state: state);
      case PracticeSessionStatus.ready:
      case PracticeSessionStatus.submittingAnswer:
        return _PracticeSession(state: state);
    }
  }
}

class _ModePicker extends ConsumerWidget {
  const _ModePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: MapingoSpacing.screenPadding,
      children: [
        Text(l10n.choosePractice, style: MapingoTypography.displaySmall),
        const SizedBox(height: MapingoSpacing.sm),
        Text(
          l10n.shortSessionsHelpReinforce,
          style: MapingoTypography.bodyMedium.copyWith(
            color: MapingoColors.grey600,
          ),
        ),
        const SizedBox(height: MapingoSpacing.xl),
        for (final mode in PracticeMode.values) ...[
          MapingoCard(
            onTap: () =>
                ref.read(practiceControllerProvider.notifier).startMode(mode),
            boxShadow: MapingoTheme.shadowSm,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: MapingoColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_iconFor(mode), color: MapingoColors.primary),
                ),
                const SizedBox(width: MapingoSpacing.base),
                Expanded(
                  child: Text(
                    _titleFor(mode, l10n),
                    style: MapingoTypography.titleLarge,
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
          const SizedBox(height: MapingoSpacing.md),
        ],
      ],
    );
  }

  IconData _iconFor(PracticeMode mode) {
    switch (mode) {
      case PracticeMode.mistakes:
        return Icons.refresh_rounded;
      case PracticeMode.capitals:
        return Icons.location_city_rounded;
      case PracticeMode.map:
        return Icons.map_rounded;
      case PracticeMode.quickChallenge:
        return Icons.bolt_rounded;
    }
  }

  String _titleFor(PracticeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case PracticeMode.mistakes:
        return l10n.reviewMistakes;
      case PracticeMode.capitals:
        return l10n.practiceCapitals;
      case PracticeMode.map:
        return l10n.practiceMap;
      case PracticeMode.quickChallenge:
        return l10n.quickChallenge;
    }
  }
}

class _PracticeSession extends ConsumerWidget {
  final PracticeSessionState state;

  const _PracticeSession({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final exercise = state.currentExercise;
    final selection = ref.watch(lessonSelectionProvider(_practiceSelectionKey));
    final isBusy = state.status == PracticeSessionStatus.submittingAnswer;

    if (exercise == null) {
      return EmptyStateView(
        icon: Icons.quiz_rounded,
        title: l10n.practiceComplete,
        message: l10n.youAnsweredEveryQuestion,
      );
    }

    return Column(
      children: [
        Padding(
          padding: MapingoSpacing.paddingBase,
          child: LinearProgressIndicator(
            minHeight: 12,
            value:
                (state.currentExerciseIndex +
                    (state.currentExerciseAnswered ? 1 : 0)) /
                state.totalExercises,
            borderRadius: MapingoTheme.borderRadiusFull,
          ),
        ),
        Expanded(
          child: ListView(
            padding: MapingoSpacing.screenPadding,
            children: [
              MapingoCard(
                boxShadow: MapingoTheme.shadowMd,
                child: Text(
                  exercise.question,
                  style: MapingoTypography.displaySmall,
                ),
              ),
              const SizedBox(height: MapingoSpacing.xl),
              _PracticeExerciseOptions(
                exercise: exercise,
                selection: selection,
                isAnswered: state.currentExerciseAnswered,
                result: state.lastAnswerResult,
              ),
            ],
          ),
        ),
        _PracticeFeedback(result: state.lastAnswerResult),
        Padding(
          padding: MapingoSpacing.paddingBase,
          child: PrimaryButton(
            label: state.currentExerciseAnswered
                ? state.isLastExercise
                      ? l10n.finish
                      : l10n.continueAction
                : l10n.check,
            icon: state.currentExerciseAnswered
                ? Icons.arrow_forward_rounded
                : Icons.check_rounded,
            isLoading: isBusy,
            onPressed: state.currentExerciseAnswered
                ? () {
                    ref
                        .read(practiceControllerProvider.notifier)
                        .nextExercise();
                    ref
                        .read(
                          lessonSelectionProvider(
                            _practiceSelectionKey,
                          ).notifier,
                        )
                        .reset();
                  }
                : selection.answerFor(exercise) == null
                ? null
                : () => ref
                      .read(practiceControllerProvider.notifier)
                      .submitAnswer(selection.answerFor(exercise)!),
          ),
        ),
      ],
    );
  }
}

class _PracticeExerciseOptions extends ConsumerWidget {
  final ExerciseModel exercise;
  final LessonSelectionState selection;
  final bool isAnswered;
  final LessonAnswerResult? result;

  const _PracticeExerciseOptions({
    required this.exercise,
    required this.selection,
    required this.isAnswered,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (exercise.exerciseType == ExerciseType.matchPairs) {
      return _PracticeMatchPairs(
        exercise: exercise,
        selection: selection,
        isAnswered: isAnswered,
      );
    }

    if (exercise.exerciseType == ExerciseType.mapTap) {
      return _PracticeMapTap(
        exercise: exercise,
        selection: selection,
        isAnswered: isAnswered,
        result: result,
      );
    }

    final options = switch (exercise.exerciseType) {
      ExerciseType.trueFalse => [l10n.trueLabel, l10n.falseLabel],
      _ => exercise.options,
    };

    return Column(
      children: [
        for (final option in options) ...[
          AnswerOptionCard(
            text: _displayOption(option, exercise, context),
            icon: Icons.touch_app_rounded,
            state: _optionState(option),
            isEnabled: !isAnswered,
            onTap: () => ref
                .read(lessonSelectionProvider(_practiceSelectionKey).notifier)
                .selectValue(option),
          ),
          const SizedBox(height: MapingoSpacing.md),
        ],
      ],
    );
  }

  AnswerOptionState _optionState(String option) {
    if (!isAnswered) {
      return option == selection.selectedValue
          ? AnswerOptionState.selected
          : AnswerOptionState.normal;
    }
    if (_same(option, exercise.correctAnswer)) return AnswerOptionState.correct;
    if (_same(option, selection.selectedValue) && result?.isCorrect == false) {
      return AnswerOptionState.incorrect;
    }
    return AnswerOptionState.normal;
  }

  String _displayOption(
    String option,
    ExerciseModel exercise,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (option == 'true') return l10n.trueLabel;
    if (option == 'false') return l10n.falseLabel;
    return option;
  }
}

class _PracticeMapTap extends ConsumerWidget {
  final ExerciseModel exercise;
  final LessonSelectionState selection;
  final bool isAnswered;
  final LessonAnswerResult? result;

  const _PracticeMapTap({
    required this.exercise,
    required this.selection,
    required this.isAnswered,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final mapContent = ref.watch(mapExplorerContentProvider);
    final wrongMapKey = result?.isCorrect == false
        ? selection.selectedValue
        : null;

    return mapContent.when(
      loading: () => LoadingView(message: l10n.loadingMap2, showLogo: false),
      error: (error, stackTrace) => ErrorView(
        title: l10n.couldNotLoadMap2,
        message: error.toString(),
        actionLabel: l10n.tryAgain,
        onAction: () => ref.invalidate(mapExplorerContentProvider),
      ),
      data: (content) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 420,
            child: MexicoMapView(
              states: content.states,
              selectedMapKey: selection.selectedValue,
              correctMapKey: exercise.correctAnswer,
              wrongMapKey: wrongMapKey,
              isFeedbackVisible: isAnswered,
              onStateTap: (state) {
                if (isAnswered) return;
                ref
                    .read(
                      lessonSelectionProvider(_practiceSelectionKey).notifier,
                    )
                    .selectValue(state.mapKey);
              },
            ),
          ),
          const SizedBox(height: MapingoSpacing.md),
          Text(
            isAnswered
                ? result?.isCorrect == true
                      ? l10n.correctStateSelected2
                      : l10n.correctStateHighlighted2
                : l10n.tapStateOnMap2,
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

class _PracticeMatchPairs extends ConsumerWidget {
  final ExerciseModel exercise;
  final LessonSelectionState selection;
  final bool isAnswered;

  const _PracticeMatchPairs({
    required this.exercise,
    required this.selection,
    required this.isAnswered,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rightOptions = exercise.metadata.pairs
        .map((pair) => pair.right)
        .toList();

    return Column(
      children: [
        for (final pair in exercise.metadata.pairs) ...[
          MapingoCard(
            boxShadow: MapingoTheme.shadowSm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pair.left, style: MapingoTypography.titleLarge),
                const SizedBox(height: MapingoSpacing.md),
                Wrap(
                  spacing: MapingoSpacing.sm,
                  runSpacing: MapingoSpacing.sm,
                  children: [
                    for (final right in rightOptions)
                      ChoiceChip(
                        label: Text(right),
                        selected: selection.selectedPairs[pair.left] == right,
                        onSelected: isAnswered
                            ? null
                            : (_) => ref
                                  .read(
                                    lessonSelectionProvider(
                                      _practiceSelectionKey,
                                    ).notifier,
                                  )
                                  .selectPair(left: pair.left, right: right),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: MapingoSpacing.md),
        ],
      ],
    );
  }
}

class _PracticeFeedback extends StatelessWidget {
  final LessonAnswerResult? result;

  const _PracticeFeedback({required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final answerResult = result;
    if (answerResult == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: MapingoSpacing.paddingBase,
      color: answerResult.isCorrect
          ? MapingoColors.successLight
          : MapingoColors.errorLight,
      child: Text(
        answerResult.isCorrect
            ? l10n.correct2
            : answerResult.explanation ?? l10n.tryAgainLater,
        style: MapingoTypography.titleMedium.copyWith(
          color: answerResult.isCorrect
              ? MapingoColors.success
              : MapingoColors.error,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PracticeComplete extends ConsumerWidget {
  final PracticeSessionState state;

  const _PracticeComplete({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: MapingoSpacing.paddingXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.celebration_rounded,
            color: MapingoColors.secondary,
            size: 96,
          ),
          const SizedBox(height: MapingoSpacing.xl),
          Text(
            l10n.practiceComplete2,
            style: MapingoTypography.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: MapingoSpacing.md),
          Text(
            l10n.practiceScoreSummary(state.correctAnswers, state.wrongAnswers),
            style: MapingoTypography.bodyLarge.copyWith(
              color: MapingoColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: MapingoSpacing.xxl),
          PrimaryButton(
            label: l10n.chooseAnotherMode2,
            icon: Icons.replay_rounded,
            onPressed: () {
              ref.read(practiceControllerProvider.notifier).reset();
              ref
                  .read(lessonSelectionProvider(_practiceSelectionKey).notifier)
                  .reset();
            },
          ),
        ],
      ),
    );
  }
}

bool _same(String? a, String? b) {
  return (a ?? '').trim().toLowerCase() == (b ?? '').trim().toLowerCase();
}
