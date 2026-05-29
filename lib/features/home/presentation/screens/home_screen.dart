import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/components/components.dart';
import '../../data/models/home_models.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeContentProvider);

    return Scaffold(
      body: homeState.when(
        loading: () => const LoadingView(message: 'Loading your path...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not load home',
          message: error.toString(),
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(homeContentProvider),
        ),
        data: (content) {
          if (content.isEmpty) {
            return EmptyStateView(
              icon: Icons.route_rounded,
              title: 'No lessons yet',
              message: 'Your learning path will appear here soon.',
              actionLabel: 'Refresh',
              onAction: () => ref.invalidate(homeContentProvider),
            );
          }

          return _HomeContent(content: content);
        },
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  final HomeContent content;

  const _HomeContent({required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: RefreshIndicator(
        color: MapingoColors.primary,
        onRefresh: () async {
          ref.invalidate(homeContentProvider);
          await ref.read(homeContentProvider.future);
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: MapingoSpacing.screenPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _HomeHeader(content: content),
                  const SizedBox(height: MapingoSpacing.xl),
                  _CurrentUnitCard(content: content),
                  const SizedBox(height: MapingoSpacing.xxl),
                  Text(
                    'Learning path',
                    style: MapingoTypography.headlineMedium.copyWith(
                      color: MapingoColors.grey900,
                    ),
                  ),
                  const SizedBox(height: MapingoSpacing.md),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                MapingoSpacing.base,
                0,
                MapingoSpacing.base,
                MapingoSpacing.xxl,
              ),
              sliver: SliverList.builder(
                itemCount: content.units.length,
                itemBuilder: (context, index) {
                  return _UnitPathSection(homeUnit: content.units[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final HomeContent content;

  const _HomeHeader({required this.content});

  @override
  Widget build(BuildContext context) {
    final profile = content.profile;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, ${profile.username ?? 'Explorador'}',
                style: MapingoTypography.displaySmall.copyWith(
                  color: MapingoColors.grey900,
                ),
              ),
              const SizedBox(height: MapingoSpacing.xs),
              Text(
                '${profile.totalXp} XP earned',
                style: MapingoTypography.bodyMedium.copyWith(
                  color: MapingoColors.grey600,
                ),
              ),
            ],
          ),
        ),
        StreakBadge(
          streakCount: profile.currentStreak,
          isActive: profile.currentStreak > 0,
        ),
      ],
    );
  }
}

class _CurrentUnitCard extends StatelessWidget {
  final HomeContent content;

  const _CurrentUnitCard({required this.content});

  @override
  Widget build(BuildContext context) {
    final currentUnit = content.currentUnit;
    final currentLesson = content.currentLesson;
    final completed =
        currentUnit?.completedLessons ??
        content.units.fold<int>(
          0,
          (total, unit) => total + unit.completedLessons,
        );
    final total =
        currentUnit?.totalLessons ??
        content.units.fold<int>(0, (total, unit) => total + unit.totalLessons);

    return MapingoCard(
      backgroundColor: MapingoColors.primarySurface,
      boxShadow: MapingoTheme.shadowMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: MapingoColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: MapingoColors.white,
                ),
              ),
              const SizedBox(width: MapingoSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current unit',
                      style: MapingoTypography.labelMedium.copyWith(
                        color: MapingoColors.primaryDark,
                      ),
                    ),
                    Text(
                      currentUnit?.unit.title ?? 'All units complete',
                      style: MapingoTypography.headlineSmall.copyWith(
                        color: MapingoColors.grey900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: MapingoSpacing.lg),
          Text(
            currentLesson == null
                ? 'You completed every lesson in the path.'
                : 'Next: ${currentLesson.lesson.title}',
            style: MapingoTypography.bodyMedium.copyWith(
              color: MapingoColors.grey700,
            ),
          ),
          const SizedBox(height: MapingoSpacing.base),
          _LessonProgressBar(completed: completed, total: total),
        ],
      ),
    );
  }
}

class _LessonProgressBar extends StatelessWidget {
  final int completed;
  final int total;

  const _LessonProgressBar({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Lessons complete',
              style: MapingoTypography.labelMedium.copyWith(
                color: MapingoColors.grey600,
              ),
            ),
            const Spacer(),
            Text(
              '$completed / $total',
              style: MapingoTypography.labelMedium.copyWith(
                color: MapingoColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: MapingoSpacing.sm),
        ClipRRect(
          borderRadius: MapingoTheme.borderRadiusFull,
          child: LinearProgressIndicator(
            minHeight: 12,
            value: progress,
            backgroundColor: MapingoColors.grey200,
            valueColor: const AlwaysStoppedAnimation(MapingoColors.primary),
          ),
        ),
      ],
    );
  }
}

class _UnitPathSection extends StatelessWidget {
  final HomeUnit homeUnit;

  const _UnitPathSection({required this.homeUnit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MapingoSpacing.xxl),
      child: MapingoCard(
        boxShadow: MapingoTheme.shadowSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homeUnit.unit.title,
                        style: MapingoTypography.headlineSmall,
                      ),
                      if (homeUnit.unit.description != null) ...[
                        const SizedBox(height: MapingoSpacing.xs),
                        Text(
                          homeUnit.unit.description!,
                          style: MapingoTypography.bodySmall.copyWith(
                            color: MapingoColors.grey600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _UnitCountBadge(
                  completed: homeUnit.completedLessons,
                  total: homeUnit.totalLessons,
                ),
              ],
            ),
            const SizedBox(height: MapingoSpacing.xl),
            if (homeUnit.lessons.isEmpty)
              const EmptyStateView(
                icon: Icons.lock_open_rounded,
                title: 'No lessons in this unit',
                message: 'Lessons will show up here when they are ready.',
              )
            else
              _LessonPath(lessons: homeUnit.lessons),
          ],
        ),
      ),
    );
  }
}

class _LessonPath extends StatelessWidget {
  final List<HomeLesson> lessons;

  const _LessonPath({required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < lessons.length; index++) ...[
          Align(
            alignment: index.isEven
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: SizedBox(
              width: 126,
              child: LessonNode(
                label: _lessonLabel(lessons[index].lesson.title),
                state: _nodeState(lessons[index].status),
                icon: _lessonIcon(lessons[index].lesson.lessonType),
                xpEarned: lessons[index].progress?.xpEarned,
                onTap: () => _handleLessonTap(context, lessons[index]),
              ),
            ),
          ),
          if (index != lessons.length - 1) const _PathConnector(),
        ],
      ],
    );
  }

  String _lessonLabel(String title) {
    return title.replaceFirst(RegExp(r'^[0-9]+\\.\\s*'), '');
  }

  LessonNodeState _nodeState(HomeLessonStatus status) {
    switch (status) {
      case HomeLessonStatus.locked:
        return LessonNodeState.locked;
      case HomeLessonStatus.unlocked:
        return LessonNodeState.available;
      case HomeLessonStatus.current:
        return LessonNodeState.current;
      case HomeLessonStatus.completed:
        return LessonNodeState.completed;
    }
  }

  IconData _lessonIcon(String lessonType) {
    switch (lessonType) {
      case 'capital_practice':
        return Icons.location_city_rounded;
      case 'map_practice':
        return Icons.map_rounded;
      case 'review':
        return Icons.fact_check_rounded;
      default:
        return Icons.play_arrow_rounded;
    }
  }

  void _handleLessonTap(BuildContext context, HomeLesson lesson) {
    if (lesson.isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Finish the lesson before this one to unlock it.'),
        ),
      );
      return;
    }

    context.pushNamed(
      AppRouteNames.lessonDetail,
      pathParameters: {'id': lesson.lesson.id},
    );
  }
}

class _PathConnector extends StatelessWidget {
  const _PathConnector();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 6,
        height: 30,
        margin: const EdgeInsets.symmetric(vertical: MapingoSpacing.sm),
        decoration: BoxDecoration(
          color: MapingoColors.grey200,
          borderRadius: MapingoTheme.borderRadiusFull,
        ),
      ),
    );
  }
}

class _UnitCountBadge extends StatelessWidget {
  final int completed;
  final int total;

  const _UnitCountBadge({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MapingoSpacing.md,
        vertical: MapingoSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: completed == total && total > 0
            ? MapingoColors.successLight
            : MapingoColors.grey100,
        borderRadius: MapingoTheme.borderRadiusFull,
      ),
      child: Text(
        '$completed/$total',
        style: MapingoTypography.labelMedium.copyWith(
          color: completed == total && total > 0
              ? MapingoColors.success
              : MapingoColors.grey600,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
