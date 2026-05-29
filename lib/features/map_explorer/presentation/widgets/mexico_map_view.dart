import 'package:flutter/material.dart';

import '../../data/models/map_state_model.dart';
import 'mexico_svg_map.dart';

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
    return MexicoSvgMap(
      states: states,
      selectedMapKey: selectedMapKey,
      correctMapKey: correctMapKey,
      wrongMapKey: wrongMapKey,
      isFeedbackVisible: isFeedbackVisible,
      onStateTap: onStateTap,
    );
  }
}
