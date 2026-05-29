import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/components/components.dart';
import '../../../achievements/data/models/achievement_models.dart';
import '../../../achievements/presentation/providers/achievement_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(startupAuthProvider);
    final statsState = ref.watch(profileStatsProvider);
    final achievementsState = ref.watch(achievementsContentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: authState.when(
        loading: () => const LoadingView(message: 'Loading profile...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not load profile',
          message: error.toString(),
          actionLabel: 'Try again',
          onAction: () => ref.read(startupAuthProvider.notifier).retry(),
        ),
        data: (session) => RefreshIndicator(
          color: MapingoColors.primary,
          onRefresh: () async {
            ref.invalidate(profileStatsProvider);
            ref.invalidate(achievementsContentProvider);
            ref.invalidate(startupAuthProvider);
            await ref.read(startupAuthProvider.future);
          },
          child: ListView(
            padding: MapingoSpacing.screenPadding,
            children: [
              _ProfileHeader(
                username: session.profile.username ?? 'Explorador',
                totalXp: session.profile.totalXp,
                currentStreak: session.profile.currentStreak,
                longestStreak: session.profile.longestStreak,
              ),
              const SizedBox(height: MapingoSpacing.xl),
              statsState.when(
                loading: () => const LoadingView(
                  message: 'Loading stats...',
                  showLogo: false,
                ),
                error: (error, stackTrace) => ErrorView(
                  title: 'Could not load stats',
                  message: error.toString(),
                  actionLabel: 'Try again',
                  onAction: () => ref.invalidate(profileStatsProvider),
                ),
                data: (stats) => _StatsGrid(
                  totalXp: session.profile.totalXp,
                  currentStreak: session.profile.currentStreak,
                  longestStreak: session.profile.longestStreak,
                  completedLessons: stats.completedLessons,
                  accuracyLabel: stats.accuracyLabel,
                ),
              ),
              const SizedBox(height: MapingoSpacing.xxl),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Achievements',
                      style: MapingoTypography.headlineMedium,
                    ),
                  ),
                  achievementsState.maybeWhen(
                    data: (content) => Text(
                      '${content.unlockedCount}/${content.achievements.length}',
                      style: MapingoTypography.labelLarge.copyWith(
                        color: MapingoColors.primary,
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: MapingoSpacing.md),
              achievementsState.when(
                loading: () => const LoadingView(
                  message: 'Loading achievements...',
                  showLogo: false,
                ),
                error: (error, stackTrace) => ErrorView(
                  title: 'Could not load achievements',
                  message: error.toString(),
                  actionLabel: 'Try again',
                  onAction: () => ref.invalidate(achievementsContentProvider),
                ),
                data: (content) => _AchievementsList(content: content),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final String username;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;

  const _ProfileHeader({
    required this.username,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapingoCard(
      boxShadow: MapingoTheme.shadowMd,
      backgroundColor: MapingoColors.primarySurface,
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: MapingoColors.white,
              shape: BoxShape.circle,
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.explore_rounded,
                  color: MapingoColors.primary,
                  size: 42,
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: MapingoColors.secondary,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: MapingoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        username,
                        style: MapingoTypography.headlineMedium.copyWith(
                          color: MapingoColors.grey900,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit username',
                      onPressed: () => _showEditUsernameDialog(
                        context: context,
                        ref: ref,
                        username: username,
                      ),
                      icon: const Icon(Icons.edit_rounded),
                    ),
                  ],
                ),
                Text(
                  '$totalXp XP - $currentStreak day streak - Best $longestStreak',
                  style: MapingoTypography.bodySmall.copyWith(
                    color: MapingoColors.grey700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditUsernameDialog({
    required BuildContext context,
    required WidgetRef ref,
    required String username,
  }) async {
    final controller = TextEditingController(text: username);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final updateState = ref.watch(usernameUpdateControllerProvider);

            return AlertDialog(
              title: const Text('Edit username'),
              content: TextField(
                controller: controller,
                maxLength: 24,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Your name',
                  counterText: '',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: updateState.isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: updateState.isLoading
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(usernameUpdateControllerProvider.notifier)
                                .updateUsername(controller.text);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Could not update your username. Please try again.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: updateState.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
  }
}

class _StatsGrid extends StatelessWidget {
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final int completedLessons;
  final String accuracyLabel;

  const _StatsGrid({
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    required this.completedLessons,
    required this.accuracyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.bolt_rounded,
                label: 'Total XP',
                value: '$totalXp',
                color: MapingoColors.secondary,
              ),
            ),
            const SizedBox(width: MapingoSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department_rounded,
                label: 'Streak',
                value: '$currentStreak',
                color: MapingoColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: MapingoSpacing.md),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.emoji_events_rounded,
                label: 'Best streak',
                value: '$longestStreak',
                color: MapingoColors.accent,
              ),
            ),
            const SizedBox(width: MapingoSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_rounded,
                label: 'Lessons',
                value: '$completedLessons',
                color: MapingoColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: MapingoSpacing.md),
        _StatCard(
          icon: Icons.track_changes_rounded,
          label: 'Accuracy',
          value: accuracyLabel,
          color: MapingoColors.info,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MapingoCard(
      boxShadow: MapingoTheme.shadowSm,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: MapingoSpacing.sm),
          Text(value, style: MapingoTypography.headlineMedium),
          Text(
            label,
            style: MapingoTypography.labelMedium.copyWith(
              color: MapingoColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsList extends StatelessWidget {
  final AchievementsContent content;

  const _AchievementsList({required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.achievements.isEmpty) {
      return const EmptyStateView(
        icon: Icons.emoji_events_rounded,
        title: 'No achievements yet',
        message: 'Achievements will appear here when they are available.',
      );
    }

    return Column(
      children: [
        for (final item in content.achievements) ...[
          _AchievementTile(item: item),
          const SizedBox(height: MapingoSpacing.md),
        ],
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final AchievementDisplayModel item;

  const _AchievementTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final achievement = item.achievement;
    final isUnlocked = item.isUnlocked;
    final progress = achievement.conditionValue == 0
        ? 0.0
        : (item.progressValue / achievement.conditionValue).clamp(0.0, 1.0);

    return MapingoCard(
      backgroundColor: isUnlocked
          ? MapingoColors.secondarySurface
          : MapingoColors.grey100,
      boxShadow: isUnlocked ? MapingoTheme.shadowSm : [],
      border: Border.all(
        color: isUnlocked ? MapingoColors.secondary : MapingoColors.grey200,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? MapingoColors.secondary
                  : MapingoColors.grey300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnlocked ? Icons.emoji_events_rounded : Icons.lock_rounded,
              color: isUnlocked ? MapingoColors.white : MapingoColors.grey600,
            ),
          ),
          const SizedBox(width: MapingoSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: MapingoTypography.titleLarge.copyWith(
                    color: isUnlocked
                        ? MapingoColors.grey900
                        : MapingoColors.grey600,
                  ),
                ),
                const SizedBox(height: MapingoSpacing.xs),
                Text(
                  achievement.description,
                  style: MapingoTypography.bodySmall.copyWith(
                    color: MapingoColors.grey600,
                  ),
                ),
                if (!isUnlocked) ...[
                  const SizedBox(height: MapingoSpacing.sm),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    borderRadius: MapingoTheme.borderRadiusFull,
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
