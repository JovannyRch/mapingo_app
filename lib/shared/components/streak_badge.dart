import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class StreakBadge extends StatelessWidget {
  final int streakCount;
  final bool isActive;
  final double size;

  const StreakBadge({
    super.key,
    required this.streakCount,
    this.isActive = true,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      MapingoColors.warning,
                      MapingoColors.secondary,
                    ],
                  )
                : null,
            color: isActive ? null : MapingoColors.grey300,
            shape: BoxShape.circle,
            boxShadow: isActive ? MapingoTheme.shadowMd : null,
          ),
          child: Center(
            child: Icon(
              Icons.local_fire_department_rounded,
              color: isActive ? MapingoColors.white : MapingoColors.grey500,
              size: size * 0.55,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          streakCount.toString(),
          style: MapingoTypography.labelLarge.copyWith(
            color: isActive ? MapingoColors.warning : MapingoColors.grey500,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
