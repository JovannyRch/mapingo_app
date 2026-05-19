import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../data/models/map_state_model.dart';

class MexicoMapView extends StatelessWidget {
  final List<MapStateModel> states;
  final String? selectedMapKey;
  final String? correctMapKey;
  final String? wrongMapKey;
  final bool isFeedbackVisible;
  final ValueChanged<MapStateModel> onStateTap;

  const MexicoMapView({
    super.key,
    required this.states,
    required this.selectedMapKey,
    this.correctMapKey,
    this.wrongMapKey,
    this.isFeedbackVisible = false,
    required this.onStateTap,
  });

  @override
  Widget build(BuildContext context) {
    final regions = _groupStatesByRegion(states);

    return InteractiveViewer(
      minScale: 0.8,
      maxScale: 2.4,
      boundaryMargin: const EdgeInsets.all(36),
      child: AspectRatio(
        aspectRatio: 0.82,
        child: Container(
          padding: MapingoSpacing.paddingBase,
          decoration: BoxDecoration(
            color: MapingoColors.infoLight,
            borderRadius: MapingoTheme.borderRadiusXl,
            border: Border.all(
              color: MapingoColors.info.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              for (final entry in regions.entries)
                Expanded(
                  flex: _regionFlex(entry.key),
                  child: _RegionBand(
                    regionName: entry.key,
                    states: entry.value,
                    selectedMapKey: selectedMapKey,
                    correctMapKey: correctMapKey,
                    wrongMapKey: wrongMapKey,
                    isFeedbackVisible: isFeedbackVisible,
                    onStateTap: onStateTap,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, List<MapStateModel>> _groupStatesByRegion(
    List<MapStateModel> states,
  ) {
    final grouped = <String, List<MapStateModel>>{};
    for (final state in states) {
      grouped.putIfAbsent(state.regionName, () => []).add(state);
    }

    for (final states in grouped.values) {
      states.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }

    return grouped;
  }

  int _regionFlex(String regionName) {
    if (regionName == 'Northern Mexico') return 3;
    if (regionName == 'Central Mexico') return 3;
    return 2;
  }
}

class _RegionBand extends StatelessWidget {
  final String regionName;
  final List<MapStateModel> states;
  final String? selectedMapKey;
  final String? correctMapKey;
  final String? wrongMapKey;
  final bool isFeedbackVisible;
  final ValueChanged<MapStateModel> onStateTap;

  const _RegionBand({
    required this.regionName,
    required this.states,
    required this.selectedMapKey,
    required this.correctMapKey,
    required this.wrongMapKey,
    required this.isFeedbackVisible,
    required this.onStateTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 420 ? 4 : 3;

        return Align(
          alignment: _alignmentFor(regionName),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: MapingoSpacing.xs,
            runSpacing: MapingoSpacing.xs,
            children: [
              for (final state in states)
                SizedBox(
                  width:
                      (constraints.maxWidth -
                          (columns - 1) * MapingoSpacing.xs) /
                      columns,
                  child: _StateTile(
                    state: state,
                    isSelected: selectedMapKey == state.mapKey,
                    isCorrect:
                        isFeedbackVisible && correctMapKey == state.mapKey,
                    isWrong: isFeedbackVisible && wrongMapKey == state.mapKey,
                    onTap: () => onStateTap(state),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Alignment _alignmentFor(String regionName) {
    if (regionName == 'Northern Mexico') return Alignment.centerLeft;
    if (regionName == 'Southeast Mexico') return Alignment.centerRight;
    return Alignment.center;
  }
}

class _StateTile extends StatelessWidget {
  final MapStateModel state;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const _StateTile({
    required this.state,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: state.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: MapingoTheme.durationFast,
          height: 42,
          decoration: BoxDecoration(
            color: _backgroundColor(),
            borderRadius: MapingoTheme.borderRadiusBase,
            border: Border.all(
              color: _borderColor(),
              width: isSelected || isCorrect || isWrong ? 3 : 2,
            ),
            boxShadow: isSelected || isCorrect || isWrong
                ? MapingoTheme.shadowPrimary
                : MapingoTheme.shadowSm,
          ),
          child: Center(
            child: Text(
              state.abbreviation,
              style: MapingoTypography.labelMedium.copyWith(
                color: isSelected || isCorrect || isWrong
                    ? MapingoColors.white
                    : MapingoColors.grey800,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor() {
    if (isCorrect) return MapingoColors.success;
    if (isWrong) return MapingoColors.error;
    if (isSelected) return MapingoColors.primary;
    return _stateColor(state);
  }

  Color _borderColor() {
    if (isCorrect) return MapingoColors.success;
    if (isWrong) return MapingoColors.error;
    if (isSelected) return MapingoColors.primaryDark;
    return MapingoColors.white;
  }

  Color _stateColor(MapStateModel state) {
    final hex = state.colorHex;
    if (hex == null || hex.length != 7) {
      return MapingoColors.white;
    }

    final value = int.tryParse(hex.substring(1), radix: 16);
    if (value == null) return MapingoColors.white;
    return Color(0xFF000000 | value).withValues(alpha: 0.55);
  }
}
