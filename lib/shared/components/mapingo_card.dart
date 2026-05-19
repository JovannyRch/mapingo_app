import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class MapingoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final double? width;
  final double? height;

  const MapingoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: MapingoTheme.durationFast,
        width: width,
        height: height,
        padding: padding ?? MapingoSpacing.paddingBase,
        decoration: BoxDecoration(
          color: backgroundColor ?? MapingoColors.white,
          borderRadius: MapingoTheme.borderRadiusLg,
          boxShadow: boxShadow ?? MapingoTheme.shadowMd,
          border: border,
        ),
        child: child,
      ),
    );
  }
}
