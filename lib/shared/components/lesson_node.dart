import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

enum LessonNodeState { locked, available, completed, current }

class LessonNode extends StatelessWidget {
  final String label;
  final LessonNodeState state;
  final IconData icon;
  final VoidCallback? onTap;
  final int? xpEarned;

  const LessonNode({
    super.key,
    required this.label,
    required this.state,
    this.icon = Icons.play_arrow_rounded,
    this.onTap,
    this.xpEarned,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = state != LessonNodeState.locked;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              shape: BoxShape.circle,
              border: state == LessonNodeState.current
                  ? Border.all(color: MapingoColors.primary, width: 3)
                  : null,
              boxShadow: isActive ? MapingoTheme.shadowMd : null,
            ),
            child: Center(child: _buildIcon()),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: MapingoTypography.labelSmall.copyWith(
              color: isActive ? MapingoColors.grey800 : MapingoColors.grey400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (xpEarned != null && xpEarned! > 0) ...[
            const SizedBox(height: 2),
            Text(
              '+$xpEarned XP',
              style: MapingoTypography.labelSmall.copyWith(
                color: MapingoColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (state) {
      case LessonNodeState.locked:
        return MapingoColors.grey200;
      case LessonNodeState.available:
        return MapingoColors.white;
      case LessonNodeState.completed:
        return MapingoColors.success;
      case LessonNodeState.current:
        return MapingoColors.primarySurface;
    }
  }

  Widget _buildIcon() {
    switch (state) {
      case LessonNodeState.locked:
        return const Icon(
          Icons.lock_rounded,
          color: MapingoColors.grey400,
          size: 28,
        );
      case LessonNodeState.available:
        return Icon(icon, color: MapingoColors.primary, size: 32);
      case LessonNodeState.completed:
        return const Icon(
          Icons.check_rounded,
          color: MapingoColors.white,
          size: 32,
        );
      case LessonNodeState.current:
        return Icon(icon, color: MapingoColors.primary, size: 32);
    }
  }
}
