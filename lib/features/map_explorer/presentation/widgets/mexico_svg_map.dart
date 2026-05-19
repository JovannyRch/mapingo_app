import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../data/models/map_state_model.dart';
import '../../data/models/mexico_state_paths.dart';

class MexicoSvgMap extends StatefulWidget {
  final List<MapStateModel> states;
  final String? selectedMapKey;
  final String? correctMapKey;
  final String? wrongMapKey;
  final bool isFeedbackVisible;
  final ValueChanged<MapStateModel> onStateTap;

  const MexicoSvgMap({
    super.key,
    required this.states,
    this.selectedMapKey,
    this.correctMapKey,
    this.wrongMapKey,
    this.isFeedbackVisible = false,
    required this.onStateTap,
  });

  @override
  State<MexicoSvgMap> createState() => _MexicoSvgMapState();
}

class _MexicoSvgMapState extends State<MexicoSvgMap> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MapingoColors.infoLight,
        borderRadius: MapingoTheme.borderRadiusXl,
        border: Border.all(
          color: MapingoColors.info.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: MapingoTheme.borderRadiusXl,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5,
          maxScale: 4.0,
          boundaryMargin: const EdgeInsets.all(50),
          child: GestureDetector(
            onTapUp: (details) => _handleTap(details.localPosition),
            child: CustomPaint(
              size: Size(
                MexicoMapPaths.viewBoxWidth,
                MexicoMapPaths.viewBoxHeight,
              ),
              painter: _MexicoMapPainter(
                states: widget.states,
                selectedMapKey: widget.selectedMapKey,
                correctMapKey: widget.correctMapKey,
                wrongMapKey: widget.wrongMapKey,
                isFeedbackVisible: widget.isFeedbackVisible,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset localPosition) {
    final statePath = _findStateAtPosition(localPosition);
    if (statePath != null) {
      final mapState = widget.states.firstWhere(
        (s) => s.mapKey.toUpperCase() == statePath.abbreviation.toUpperCase(),
        orElse: () => widget.states.first,
      );
      widget.onStateTap(mapState);
    }
  }

  MexicoStatePath? _findStateAtPosition(Offset position) {
    final matrix = _transformationController.value;
    final inverseMatrix = Matrix4.inverted(matrix);
    final transformed = MatrixUtils.transformPoint(inverseMatrix, position);

    for (final statePath in MexicoMapPaths.states.reversed) {
      final path = _parsePath(statePath.path);
      if (path.contains(transformed)) {
        return statePath;
      }
    }
    return null;
  }

  Path _parsePath(String pathString) {
    final path = Path();
    final commands = pathString.split(RegExp(r'(?=[MLZmlz])'));

    for (final cmd in commands) {
      if (cmd.isEmpty) continue;

      final type = cmd[0];
      final coords = cmd.substring(1).trim();
      if (coords.isEmpty) continue;

      final parts = coords.split(RegExp(r'[\s,]+')).where((s) => s.isNotEmpty).toList();

      switch (type) {
        case 'M':
          if (parts.length >= 2) {
            path.moveTo(double.parse(parts[0]), double.parse(parts[1]));
          }
          break;
        case 'L':
          if (parts.length >= 2) {
            path.lineTo(double.parse(parts[0]), double.parse(parts[1]));
          }
          break;
        case 'Z':
          path.close();
          break;
        case 'm':
          if (parts.length >= 2) {
            path.moveTo(double.parse(parts[0]), double.parse(parts[1]));
          }
          break;
        case 'l':
          if (parts.length >= 2) {
            path.lineTo(double.parse(parts[0]), double.parse(parts[1]));
          }
          break;
        case 'z':
          path.close();
          break;
      }
    }

    return path;
  }
}

class _MexicoMapPainter extends CustomPainter {
  final List<MapStateModel> states;
  final String? selectedMapKey;
  final String? correctMapKey;
  final String? wrongMapKey;
  final bool isFeedbackVisible;

  _MexicoMapPainter({
    required this.states,
    this.selectedMapKey,
    this.correctMapKey,
    this.wrongMapKey,
    required this.isFeedbackVisible,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / MexicoMapPaths.viewBoxWidth;
    final scaleY = size.height / MexicoMapPaths.viewBoxHeight;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    for (final statePath in MexicoMapPaths.states) {
      final stateColor = _getStateColor(statePath.abbreviation);
      final fillPaint = Paint()
        ..color = stateColor
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = _getStateBorderColor(statePath.abbreviation)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _getBorderWidth(statePath.abbreviation);

      final path = _parsePath(statePath.path);
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);

      _drawStateLabel(canvas, statePath, scaleX);
    }

    canvas.restore();
  }

  Color _getStateColor(String abbreviation) {
    final isSelected = selectedMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isCorrect = isFeedbackVisible && correctMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isWrong = isFeedbackVisible && wrongMapKey?.toUpperCase() == abbreviation.toUpperCase();

    if (isCorrect) return MapingoColors.success.withValues(alpha: 0.8);
    if (isWrong) return MapingoColors.error.withValues(alpha: 0.8);
    if (isSelected) return MapingoColors.primary.withValues(alpha: 0.8);

    final state = states.firstWhere(
      (s) => s.abbreviation.toUpperCase() == abbreviation.toUpperCase(),
      orElse: () => states.first,
    );

    return _colorFromHex(state.colorHex);
  }

  Color _getStateBorderColor(String abbreviation) {
    final isSelected = selectedMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isCorrect = isFeedbackVisible && correctMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isWrong = isFeedbackVisible && wrongMapKey?.toUpperCase() == abbreviation.toUpperCase();

    if (isCorrect) return MapingoColors.successDark;
    if (isWrong) return MapingoColors.errorDark;
    if (isSelected) return MapingoColors.primaryDark;
    return MapingoColors.grey400;
  }

  double _getBorderWidth(String abbreviation) {
    final isSelected = selectedMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isCorrect = isFeedbackVisible && correctMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isWrong = isFeedbackVisible && wrongMapKey?.toUpperCase() == abbreviation.toUpperCase();

    if (isSelected || isCorrect || isWrong) return 3.0;
    return 1.0;
  }

  void _drawStateLabel(Canvas canvas, MexicoStatePath statePath, double scale) {
    final textStyle = ui.TextStyle(
      color: _getTextColor(statePath.abbreviation),
      fontSize: 10 / scale.clamp(0.5, 2.0),
      fontWeight: FontWeight.bold,
    );

    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10 / scale.clamp(0.5, 2.0),
    ))
      ..pushStyle(textStyle)
      ..addText(statePath.abbreviation);

    final paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 60));

    final offset = Offset(
      statePath.center.dx - paragraph.width / 2,
      statePath.center.dy - paragraph.height / 2,
    );

    canvas.drawParagraph(paragraph, offset);
  }

  Color _getTextColor(String abbreviation) {
    final isSelected = selectedMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isCorrect = isFeedbackVisible && correctMapKey?.toUpperCase() == abbreviation.toUpperCase();
    final isWrong = isFeedbackVisible && wrongMapKey?.toUpperCase() == abbreviation.toUpperCase();

    if (isSelected || isCorrect || isWrong) return MapingoColors.white;
    return MapingoColors.grey800;
  }

  Color _colorFromHex(String? hex) {
    if (hex == null || hex.length != 7) {
      return MapingoColors.grey300;
    }
    final value = int.tryParse(hex.substring(1), radix: 16);
    if (value == null) return MapingoColors.grey300;
    return Color(0xFF000000 | value).withValues(alpha: 0.6);
  }

  Path _parsePath(String pathString) {
    final path = Path();
    final commands = pathString.split(RegExp(r'(?=[MLZmlz])'));

    double currentX = 0;
    double currentY = 0;

    for (final cmd in commands) {
      if (cmd.isEmpty) continue;

      final type = cmd[0];
      final coords = cmd.substring(1).trim();
      if (coords.isEmpty) continue;

      final parts = coords.split(RegExp(r'[\s,]+')).where((s) => s.isNotEmpty).toList();

      switch (type) {
        case 'M':
          if (parts.length >= 2) {
            currentX = double.parse(parts[0]);
            currentY = double.parse(parts[1]);
            path.moveTo(currentX, currentY);
          }
          break;
        case 'L':
          if (parts.length >= 2) {
            currentX = double.parse(parts[0]);
            currentY = double.parse(parts[1]);
            path.lineTo(currentX, currentY);
          }
          break;
        case 'Z':
          path.close();
          break;
        case 'm':
          if (parts.length >= 2) {
            currentX += double.parse(parts[0]);
            currentY += double.parse(parts[1]);
            path.moveTo(currentX, currentY);
          }
          break;
        case 'l':
          if (parts.length >= 2) {
            currentX += double.parse(parts[0]);
            currentY += double.parse(parts[1]);
            path.lineTo(currentX, currentY);
          }
          break;
        case 'z':
          path.close();
          break;
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _MexicoMapPainter oldDelegate) {
    return oldDelegate.selectedMapKey != selectedMapKey ||
        oldDelegate.correctMapKey != correctMapKey ||
        oldDelegate.wrongMapKey != wrongMapKey ||
        oldDelegate.isFeedbackVisible != isFeedbackVisible ||
        oldDelegate.states != states;
  }
}