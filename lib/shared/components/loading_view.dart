import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class LoadingView extends StatelessWidget {
  final String? message;
  final bool showLogo;

  const LoadingView({
    super.key,
    this.message,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showLogo) ...[
            Icon(
              Icons.map_rounded,
              size: 64,
              color: MapingoColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Mapingo',
              style: MapingoTypography.headlineLarge.copyWith(
                color: MapingoColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 32),
          ],
          const CircularProgressIndicator(
            color: MapingoColors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: MapingoTypography.bodyMedium.copyWith(
                color: MapingoColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
