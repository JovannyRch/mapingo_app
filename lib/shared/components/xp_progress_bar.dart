import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class XPProgressBar extends StatelessWidget {
  final int currentXP;
  final int maxXP;
  final String? label;
  final bool showNumbers;
  final double height;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
    this.label,
    this.showNumbers = true,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxXP > 0 ? (currentXP / maxXP).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showNumbers) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: MapingoTypography.labelMedium.copyWith(
                    color: MapingoColors.grey600,
                  ),
                ),
              if (showNumbers)
                Text(
                  '$currentXP / $maxXP XP',
                  style: MapingoTypography.labelMedium.copyWith(
                    color: MapingoColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: MapingoColors.grey200,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    MapingoColors.primary,
                    MapingoColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
