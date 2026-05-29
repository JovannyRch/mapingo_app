import 'dart:math' as math;
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
    return AspectRatio(
      aspectRatio: _mapBounds.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: MapingoColors.infoLight,
          borderRadius: MapingoTheme.borderRadiusXl,
          border: Border.all(color: MapingoColors.info.withValues(alpha: 0.2)),
        ),
        child: ClipRRect(
          borderRadius: MapingoTheme.borderRadiusXl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewportSize = constraints.biggest;

              return InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1,
                maxScale: 4,
                boundaryMargin: const EdgeInsets.all(56),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) =>
                      _handleTap(details.localPosition, viewportSize),
                  child: CustomPaint(
                    size: viewportSize,
                    painter: _MexicoMapPainter(
                      states: widget.states,
                      selectedMapKey: widget.selectedMapKey,
                      correctMapKey: widget.correctMapKey,
                      wrongMapKey: widget.wrongMapKey,
                      isFeedbackVisible: widget.isFeedbackVisible,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset localPosition, Size viewportSize) {
    final statePath = _findStateAtPosition(localPosition, viewportSize);
    if (statePath == null) return;

    for (final state in widget.states) {
      if (state.abbreviation.toUpperCase() ==
          statePath.abbreviation.toUpperCase()) {
        widget.onStateTap(state);
        return;
      }
    }
  }

  MexicoStatePath? _findStateAtPosition(Offset position, Size viewportSize) {
    final inverseViewerMatrix = Matrix4.inverted(
      _transformationController.value,
    );
    final paintPosition = MatrixUtils.transformPoint(
      inverseViewerMatrix,
      position,
    );
    final mapPosition = _screenToMap(paintPosition, viewportSize);

    for (final statePath in MexicoMapPaths.states.reversed) {
      final path = _parsePath(statePath.path);
      if (path.contains(mapPosition)) {
        return statePath;
      }
    }
    return null;
  }

  Offset _screenToMap(Offset position, Size viewportSize) {
    final transform = _mapTransform(viewportSize);
    return Offset(
      (position.dx - transform.dx) / transform.scale,
      (position.dy - transform.dy) / transform.scale,
    );
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
    final transform = _mapTransform(size);

    canvas.save();
    canvas.translate(transform.dx, transform.dy);
    canvas.scale(transform.scale);

    for (final statePath in MexicoMapPaths.states) {
      final fillPaint = Paint()
        ..color = _getStateColor(statePath.abbreviation)
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = _getStateBorderColor(statePath.abbreviation)
        ..style = PaintingStyle.stroke
        ..strokeWidth =
            _getBorderWidth(statePath.abbreviation) / transform.scale;

      final path = _parsePath(statePath.path);
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
      _drawStateLabel(canvas, statePath, transform.scale);
    }

    canvas.restore();
  }

  Color _getStateColor(String abbreviation) {
    final isSelected = _matchesStateKey(abbreviation, selectedMapKey);
    final isCorrect =
        isFeedbackVisible && _matchesStateKey(abbreviation, correctMapKey);
    final isWrong =
        isFeedbackVisible && _matchesStateKey(abbreviation, wrongMapKey);

    if (isCorrect) return MapingoColors.success.withValues(alpha: 0.8);
    if (isWrong) return MapingoColors.error.withValues(alpha: 0.8);
    if (isSelected) return MapingoColors.primary.withValues(alpha: 0.8);

    return _colorFromHex(_stateForAbbreviation(abbreviation)?.colorHex);
  }

  Color _getStateBorderColor(String abbreviation) {
    final isSelected = _matchesStateKey(abbreviation, selectedMapKey);
    final isCorrect =
        isFeedbackVisible && _matchesStateKey(abbreviation, correctMapKey);
    final isWrong =
        isFeedbackVisible && _matchesStateKey(abbreviation, wrongMapKey);

    if (isCorrect) return MapingoColors.successDark;
    if (isWrong) return MapingoColors.errorDark;
    if (isSelected) return MapingoColors.primaryDark;
    return MapingoColors.white.withValues(alpha: 0.9);
  }

  double _getBorderWidth(String abbreviation) {
    final isSelected = _matchesStateKey(abbreviation, selectedMapKey);
    final isCorrect =
        isFeedbackVisible && _matchesStateKey(abbreviation, correctMapKey);
    final isWrong =
        isFeedbackVisible && _matchesStateKey(abbreviation, wrongMapKey);

    if (isSelected || isCorrect || isWrong) return 3.2;
    return 1.4;
  }

  void _drawStateLabel(Canvas canvas, MexicoStatePath statePath, double scale) {
    final bounds = _parsePath(statePath.path).getBounds();
    if (bounds.isEmpty) return;

    final paragraphBuilder =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              textAlign: TextAlign.center,
              fontSize: 13 / scale,
            ),
          )
          ..pushStyle(
            ui.TextStyle(
              color: _getTextColor(statePath.abbreviation),
              fontSize: 13 / scale,
              fontWeight: FontWeight.w800,
            ),
          )
          ..addText(statePath.abbreviation);

    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: 64 / scale));

    final offset = Offset(
      bounds.center.dx - paragraph.width / 2,
      bounds.center.dy - paragraph.height / 2,
    );

    canvas.drawParagraph(paragraph, offset);
  }

  Color _getTextColor(String abbreviation) {
    final isSelected = _matchesStateKey(abbreviation, selectedMapKey);
    final isCorrect =
        isFeedbackVisible && _matchesStateKey(abbreviation, correctMapKey);
    final isWrong =
        isFeedbackVisible && _matchesStateKey(abbreviation, wrongMapKey);

    if (isSelected || isCorrect || isWrong) return MapingoColors.white;
    return MapingoColors.grey900;
  }

  MapStateModel? _stateForAbbreviation(String abbreviation) {
    for (final state in states) {
      if (state.abbreviation.toUpperCase() == abbreviation.toUpperCase()) {
        return state;
      }
    }
    return null;
  }

  bool _matchesStateKey(String abbreviation, String? key) {
    if (key == null) return false;
    final normalizedKey = key.toUpperCase();
    if (normalizedKey == abbreviation.toUpperCase()) return true;

    final state = _stateForAbbreviation(abbreviation);
    return state?.mapKey.toUpperCase() == normalizedKey;
  }

  Color _colorFromHex(String? hex) {
    if (hex == null || hex.length != 7) return MapingoColors.grey300;

    final value = int.tryParse(hex.substring(1), radix: 16);
    if (value == null) return MapingoColors.grey300;
    return Color(0xFF000000 | value).withValues(alpha: 0.62);
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

class _MapBounds {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const _MapBounds({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  double get width => right - left;

  double get height => bottom - top;

  double get aspectRatio => width / height;

  factory _MapBounds.fromPaths(List<MexicoStatePath> states) {
    var left = double.infinity;
    var top = double.infinity;
    var right = double.negativeInfinity;
    var bottom = double.negativeInfinity;

    for (final state in states) {
      final bounds = _parsePath(state.path).getBounds();
      left = math.min(left, bounds.left);
      top = math.min(top, bounds.top);
      right = math.max(right, bounds.right);
      bottom = math.max(bottom, bounds.bottom);
    }

    return _MapBounds(left: left, top: top, right: right, bottom: bottom);
  }
}

class _MapTransform {
  final double scale;
  final double dx;
  final double dy;

  const _MapTransform({
    required this.scale,
    required this.dx,
    required this.dy,
  });
}

final _mapBounds = _MapBounds.fromPaths(MexicoMapPaths.states);

_MapTransform _mapTransform(Size size) {
  const padding = 18.0;
  final availableWidth = math.max(1, size.width - padding * 2);
  final availableHeight = math.max(1, size.height - padding * 2);
  final scale = math.min(
    availableWidth / _mapBounds.width,
    availableHeight / _mapBounds.height,
  );
  final dx =
      (size.width - _mapBounds.width * scale) / 2 - _mapBounds.left * scale;
  final dy =
      (size.height - _mapBounds.height * scale) / 2 - _mapBounds.top * scale;

  return _MapTransform(scale: scale, dx: dx, dy: dy);
}

Path _parsePath(String pathString) {
  final path = Path();

  final tokens = RegExp(
    r'[A-Za-z]|[-+]?(?:\d*\.\d+|\d+\.?)(?:[eE][-+]?\d+)?',
  ).allMatches(pathString).map((match) => match.group(0)!).toList();

  var index = 0;
  var command = '';
  var current = Offset.zero;
  var subpathStart = Offset.zero;

  bool isCommand(String value) => RegExp(r'^[A-Za-z]$').hasMatch(value);

  bool hasNumber() => index < tokens.length && !isCommand(tokens[index]);

  double readNumber() => double.parse(tokens[index++]);

  while (index < tokens.length) {
    if (isCommand(tokens[index])) {
      command = tokens[index++];
    }

    switch (command) {
      case 'M':
      case 'm':
        var isFirstPoint = true;
        while (hasNumber()) {
          final x = readNumber();
          final y = readNumber();
          final point = command == 'm'
              ? Offset(current.dx + x, current.dy + y)
              : Offset(x, y);

          if (isFirstPoint) {
            path.moveTo(point.dx, point.dy);
            subpathStart = point;
            isFirstPoint = false;
          } else {
            path.lineTo(point.dx, point.dy);
          }
          current = point;
        }
        break;
      case 'L':
      case 'l':
        while (hasNumber()) {
          final x = readNumber();
          final y = readNumber();
          current = command == 'l'
              ? Offset(current.dx + x, current.dy + y)
              : Offset(x, y);
          path.lineTo(current.dx, current.dy);
        }
        break;
      case 'H':
      case 'h':
        while (hasNumber()) {
          final x = readNumber();
          current = command == 'h'
              ? Offset(current.dx + x, current.dy)
              : Offset(x, current.dy);
          path.lineTo(current.dx, current.dy);
        }
        break;
      case 'V':
      case 'v':
        while (hasNumber()) {
          final y = readNumber();
          current = command == 'v'
              ? Offset(current.dx, current.dy + y)
              : Offset(current.dx, y);
          path.lineTo(current.dx, current.dy);
        }
        break;
      case 'C':
      case 'c':
        while (hasNumber()) {
          final x1 = readNumber();
          final y1 = readNumber();
          final x2 = readNumber();
          final y2 = readNumber();
          final x = readNumber();
          final y = readNumber();

          if (command == 'c') {
            path.relativeCubicTo(x1, y1, x2, y2, x, y);
            current = Offset(current.dx + x, current.dy + y);
          } else {
            path.cubicTo(x1, y1, x2, y2, x, y);
            current = Offset(x, y);
          }
        }
        break;
      case 'Z':
      case 'z':
        path.close();
        current = subpathStart;
        break;
      default:
        index++;
        break;
    }
  }

  return path;
}
