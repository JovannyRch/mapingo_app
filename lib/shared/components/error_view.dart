import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ErrorView({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Please try again later.',
    this.icon = Icons.error_outline_rounded,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: MapingoSpacing.paddingXl,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: MapingoColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: MapingoColors.error),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: MapingoTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: MapingoTypography.bodyMedium.copyWith(
                  color: MapingoColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(actionLabel!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MapingoColors.primary,
                    foregroundColor: MapingoColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: MapingoTheme.borderRadiusFull,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
