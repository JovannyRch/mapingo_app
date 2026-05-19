import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/components/components.dart';
import '../../data/models/map_state_model.dart';
import '../providers/map_explorer_provider.dart';
import '../widgets/mexico_map_view.dart';

class MapExplorerScreen extends ConsumerWidget {
  const MapExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentState = ref.watch(mapExplorerContentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map Explorer')),
      body: contentState.when(
        loading: () => const LoadingView(message: 'Loading Mexico map...'),
        error: (error, stackTrace) => ErrorView(
          title: 'Could not load map',
          message: error.toString(),
          actionLabel: 'Try again',
          onAction: () => ref.invalidate(mapExplorerContentProvider),
        ),
        data: (content) {
          if (content.isEmpty) {
            return EmptyStateView(
              icon: Icons.map_rounded,
              title: 'No map data yet',
              message: 'Mexican states will appear here when content is ready.',
              actionLabel: 'Refresh',
              onAction: () => ref.invalidate(mapExplorerContentProvider),
            );
          }

          return _MapExplorerContent(content: content);
        },
      ),
    );
  }
}

class _MapExplorerContent extends ConsumerWidget {
  final MapExplorerContent content;

  const _MapExplorerContent({required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMapKey = ref.watch(selectedMapKeyProvider);
    final selectedState = _selectedState(selectedMapKey);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: MapingoSpacing.screenPadding,
              children: [
                Text(
                  'Explore Mexico',
                  style: MapingoTypography.displaySmall.copyWith(
                    color: MapingoColors.grey900,
                  ),
                ),
                const SizedBox(height: MapingoSpacing.sm),
                Text(
                  'Tap any state to see its capital, region, and a fun fact.',
                  style: MapingoTypography.bodyMedium.copyWith(
                    color: MapingoColors.grey600,
                  ),
                ),
                const SizedBox(height: MapingoSpacing.xl),
                MexicoMapView(
                  states: content.states,
                  selectedMapKey: selectedMapKey,
                  onStateTap: (state) {
                    ref.read(selectedMapKeyProvider.notifier).state =
                        state.mapKey;
                  },
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: MapingoTheme.durationNormal,
            child: selectedState == null
                ? const _MapPromptCard()
                : _StateInfoCard(
                    key: ValueKey(selectedState.mapKey),
                    state: selectedState,
                    progress: content.progressByMapKey[selectedState.mapKey],
                  ),
          ),
        ],
      ),
    );
  }

  MapStateModel? _selectedState(String? selectedMapKey) {
    if (selectedMapKey == null) return null;
    for (final state in content.states) {
      if (state.mapKey == selectedMapKey) return state;
    }
    return null;
  }
}

class _MapPromptCard extends StatelessWidget {
  const _MapPromptCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: MapingoSpacing.paddingBase,
      child: MapingoCard(
        boxShadow: [],
        backgroundColor: MapingoColors.primarySurface,
        child: Row(
          children: [
            Icon(Icons.touch_app_rounded, color: MapingoColors.primary),
            SizedBox(width: MapingoSpacing.md),
            Expanded(
              child: Text(
                'Choose a state on the map.',
                style: MapingoTypography.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateInfoCard extends StatelessWidget {
  final MapStateModel state;
  final MapStateProgressModel? progress;

  const _StateInfoCard({
    super.key,
    required this.state,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: MapingoSpacing.paddingBase,
      decoration: const BoxDecoration(
        color: MapingoColors.white,
        border: Border(top: BorderSide(color: MapingoColors.grey200)),
      ),
      child: MapingoCard(
        boxShadow: MapingoTheme.shadowMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: MapingoColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      state.abbreviation,
                      style: MapingoTypography.labelLarge.copyWith(
                        color: MapingoColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: MapingoSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.name, style: MapingoTypography.headlineMedium),
                      Text(
                        state.regionName,
                        style: MapingoTypography.bodySmall.copyWith(
                          color: MapingoColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: MapingoSpacing.base),
            _InfoRow(
              icon: Icons.location_city_rounded,
              label: 'Capital',
              value: state.capital,
            ),
            const SizedBox(height: MapingoSpacing.sm),
            _InfoRow(
              icon: Icons.school_rounded,
              label: 'Progress',
              value: progress?.label ?? 'No practice yet',
            ),
            if (state.funFact != null) ...[
              const SizedBox(height: MapingoSpacing.base),
              Text(
                'Fun fact',
                style: MapingoTypography.labelMedium.copyWith(
                  color: MapingoColors.primary,
                ),
              ),
              const SizedBox(height: MapingoSpacing.xs),
              Text(
                state.funFact!,
                style: MapingoTypography.bodyMedium.copyWith(
                  color: MapingoColors.grey700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: MapingoColors.primary, size: 22),
        const SizedBox(width: MapingoSpacing.sm),
        Text(
          '$label: ',
          style: MapingoTypography.labelMedium.copyWith(
            color: MapingoColors.grey600,
          ),
        ),
        Expanded(child: Text(value, style: MapingoTypography.titleMedium)),
      ],
    );
  }
}
