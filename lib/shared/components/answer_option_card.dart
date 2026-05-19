import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

enum AnswerOptionState { normal, selected, correct, incorrect }

class AnswerOptionCard extends StatelessWidget {
  final String text;
  final String? subtitle;
  final IconData? icon;
  final AnswerOptionState state;
  final VoidCallback? onTap;
  final bool isEnabled;

  const AnswerOptionCard({
    super.key,
    required this.text,
    this.subtitle,
    this.icon,
    this.state = AnswerOptionState.normal,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: MapingoTheme.durationFast,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: MapingoTheme.borderRadiusXl,
          border: Border.all(
            color: _getBorderColor(),
            width: state == AnswerOptionState.normal ? 2 : 3,
          ),
          boxShadow: state == AnswerOptionState.selected
              ? MapingoTheme.shadowPrimary
              : MapingoTheme.shadowSm,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: MapingoTheme.borderRadiusSm,
                ),
                child: Icon(
                  icon,
                  color: _getIconColor(),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: MapingoTypography.titleMedium.copyWith(
                      color: _getTextColor(),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: MapingoTypography.bodySmall.copyWith(
                        color: _getSubtitleColor(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (state == AnswerOptionState.correct)
              const Icon(
                Icons.check_circle_rounded,
                color: MapingoColors.success,
                size: 28,
              ),
            if (state == AnswerOptionState.incorrect)
              const Icon(
                Icons.cancel_rounded,
                color: MapingoColors.error,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (state) {
      case AnswerOptionState.normal:
        return MapingoColors.white;
      case AnswerOptionState.selected:
        return MapingoColors.primarySurface;
      case AnswerOptionState.correct:
        return MapingoColors.successLight;
      case AnswerOptionState.incorrect:
        return MapingoColors.errorLight;
    }
  }

  Color _getBorderColor() {
    switch (state) {
      case AnswerOptionState.normal:
        return MapingoColors.grey300;
      case AnswerOptionState.selected:
        return MapingoColors.primary;
      case AnswerOptionState.correct:
        return MapingoColors.success;
      case AnswerOptionState.incorrect:
        return MapingoColors.error;
    }
  }

  Color _getIconBackgroundColor() {
    switch (state) {
      case AnswerOptionState.normal:
        return MapingoColors.grey100;
      case AnswerOptionState.selected:
        return MapingoColors.primary;
      case AnswerOptionState.correct:
        return MapingoColors.success;
      case AnswerOptionState.incorrect:
        return MapingoColors.error;
    }
  }

  Color _getIconColor() {
    switch (state) {
      case AnswerOptionState.normal:
        return MapingoColors.grey600;
      case AnswerOptionState.selected:
      case AnswerOptionState.correct:
      case AnswerOptionState.incorrect:
        return MapingoColors.white;
    }
  }

  Color _getTextColor() {
    switch (state) {
      case AnswerOptionState.normal:
        return MapingoColors.grey800;
      case AnswerOptionState.selected:
        return MapingoColors.primary;
      case AnswerOptionState.correct:
        return MapingoColors.success;
      case AnswerOptionState.incorrect:
        return MapingoColors.error;
    }
  }

  Color _getSubtitleColor() {
    switch (state) {
      case AnswerOptionState.normal:
        return MapingoColors.grey500;
      case AnswerOptionState.selected:
        return MapingoColors.primaryLight;
      case AnswerOptionState.correct:
        return MapingoColors.success;
      case AnswerOptionState.incorrect:
        return MapingoColors.error;
    }
  }
}
