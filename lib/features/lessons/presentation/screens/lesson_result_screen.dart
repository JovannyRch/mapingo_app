import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/components/components.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/lesson_engine_controller.dart';
import '../providers/lesson_engine_state.dart';

class LessonResultScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonResultScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonResultScreen> createState() => _LessonResultScreenState();
}

class _LessonResultScreenState extends ConsumerState<LessonResultScreen> {
  bool _completionRequested = false;

  @override
  Widget build(BuildContext context) {
    final engineState = ref.watch(lessonEngineProvider(widget.lessonId));
    final profile = ref.watch(currentProfileProvider);

    return Scaffold(
      body: engineState.when(
        loading: () => const LoadingView(message: 'Preparing results...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not load results',
          message: error.toString(),
          actionLabel: 'Go home',
          onAction: () => context.go(AppRoutes.home),
        ),
        data: (state) {
          _ensureCompleted(state);

          if (state.status == LessonEngineStatus.completing) {
            return const LoadingView(message: 'Saving your progress...');
          }

          return _ResultContent(
            state: state,
            streakCount: profile?.currentStreak ?? 0,
          );
        },
      ),
    );
  }

  void _ensureCompleted(LessonEngineState state) {
    if (_completionRequested ||
        state.status == LessonEngineStatus.completed ||
        state.progress != null ||
        !state.canComplete) {
      return;
    }

    _completionRequested = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(lessonEngineProvider(widget.lessonId).notifier).completeLesson();
    });
  }
}

class _ResultContent extends StatelessWidget {
  final LessonEngineState state;
  final int streakCount;

  const _ResultContent({required this.state, required this.streakCount});

  @override
  Widget build(BuildContext context) {
    final accuracy = state.accuracy.round();
    final message = _messageFor(accuracy);

    return SafeArea(
      child: Padding(
        padding: MapingoSpacing.paddingXl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1),
              duration: MapingoTheme.durationSlow,
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: const _CelebrationBadge(),
            ),
            const SizedBox(height: MapingoSpacing.xl),
            Text(
              'Lesson complete',
              style: MapingoTypography.displayMedium.copyWith(
                color: MapingoColors.grey900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: MapingoSpacing.sm),
            Text(
              message,
              style: MapingoTypography.bodyLarge.copyWith(
                color: MapingoColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: MapingoSpacing.xxl),
            _StatsGrid(
              xpEarned: state.xpEarned,
              accuracy: accuracy,
              correctAnswers: state.correctAnswers,
              wrongAnswers: state.wrongAnswers,
            ),
            const SizedBox(height: MapingoSpacing.base),
            _StreakCard(streakCount: streakCount),
            const Spacer(),
            PrimaryButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }

  String _messageFor(int accuracy) {
    if (accuracy >= 90) {
      return 'Outstanding map work. You are flying through Mexico.';
    }
    if (accuracy >= 70) {
      return 'Strong progress. Keep the learning streak going.';
    }
    return 'Good effort. Mistakes are saved so you can practice them later.';
  }
}

class _CelebrationBadge extends StatelessWidget {
  const _CelebrationBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 148,
        height: 148,
        decoration: BoxDecoration(
          color: MapingoColors.secondarySurface,
          shape: BoxShape.circle,
          border: Border.all(color: MapingoColors.white, width: 8),
          boxShadow: MapingoTheme.shadowLg,
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 24,
              right: 28,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: MapingoColors.secondary,
                size: 30,
              ),
            ),
            Icon(
              Icons.emoji_events_rounded,
              color: MapingoColors.secondary,
              size: 84,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final int xpEarned;
  final int accuracy;
  final int correctAnswers;
  final int wrongAnswers;

  const _StatsGrid({
    required this.xpEarned,
    required this.accuracy,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _ResultStat(
              icon: Icons.bolt_rounded,
              label: 'XP earned',
              value: '$xpEarned',
              color: MapingoColors.secondary,
            ),
            const SizedBox(width: MapingoSpacing.md),
            _ResultStat(
              icon: Icons.track_changes_rounded,
              label: 'Accuracy',
              value: '$accuracy%',
              color: MapingoColors.info,
            ),
          ],
        ),
        const SizedBox(height: MapingoSpacing.md),
        Row(
          children: [
            _ResultStat(
              icon: Icons.check_circle_rounded,
              label: 'Correct',
              value: '$correctAnswers',
              color: MapingoColors.success,
            ),
            const SizedBox(width: MapingoSpacing.md),
            _ResultStat(
              icon: Icons.cancel_rounded,
              label: 'Wrong',
              value: '$wrongAnswers',
              color: MapingoColors.error,
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResultStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MapingoCard(
        boxShadow: MapingoTheme.shadowSm,
        child: Column(
          children: [
            Icon(icon, color: color, size: 34),
            const SizedBox(height: MapingoSpacing.sm),
            Text(
              value,
              style: MapingoTypography.headlineLarge.copyWith(
                color: MapingoColors.grey900,
              ),
            ),
            Text(
              label,
              style: MapingoTypography.labelMedium.copyWith(
                color: MapingoColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streakCount;

  const _StreakCard({required this.streakCount});

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      backgroundColor: MapingoColors.warningLight,
      boxShadow: MapingoTheme.shadowSm,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: MapingoColors.warning,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: MapingoColors.white,
            ),
          ),
          const SizedBox(width: MapingoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily streak',
                  style: MapingoTypography.labelMedium.copyWith(
                    color: MapingoColors.grey600,
                  ),
                ),
                Text(
                  streakCount == 1
                      ? '1 day active'
                      : '$streakCount days active',
                  style: MapingoTypography.titleLarge.copyWith(
                    color: MapingoColors.grey900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
