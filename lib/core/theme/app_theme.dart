import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

abstract final class MapingoTheme {
  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusBase = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Border Radius Objects
  static final BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusBase = BorderRadius.circular(radiusBase);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // Shadows
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: MapingoColors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: MapingoColors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: MapingoColors.black.withValues(alpha: 0.1),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get shadowPrimary => [
    BoxShadow(
      color: MapingoColors.primary.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Duration
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: MapingoColors.primary,
      primaryContainer: MapingoColors.primarySurface,
      secondary: MapingoColors.secondary,
      secondaryContainer: MapingoColors.secondarySurface,
      tertiary: MapingoColors.accent,
      error: MapingoColors.error,
      surface: MapingoColors.surfaceLight,
      onPrimary: MapingoColors.white,
      onSecondary: MapingoColors.black,
      onSurface: MapingoColors.grey900,
    ),
    scaffoldBackgroundColor: MapingoColors.backgroundLight,
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: AppBarTheme(
      backgroundColor: MapingoColors.white,
      foregroundColor: MapingoColors.grey900,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: MapingoTypography.headlineMedium.copyWith(
        color: MapingoColors.grey900,
      ),
    ),
    cardTheme: CardThemeData(
      color: MapingoColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusLg,
      ),
      shadowColor: MapingoColors.black.withValues(alpha: 0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MapingoColors.primary,
        foregroundColor: MapingoColors.white,
        disabledBackgroundColor: MapingoColors.grey300,
        disabledForegroundColor: MapingoColors.grey500,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusFull,
        ),
        textStyle: MapingoTypography.buttonLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: MapingoColors.primary,
        disabledForegroundColor: MapingoColors.grey400,
        side: const BorderSide(color: MapingoColors.primary, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusFull,
        ),
        textStyle: MapingoTypography.buttonLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MapingoColors.primary,
        disabledForegroundColor: MapingoColors.grey400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusBase,
        ),
        textStyle: MapingoTypography.buttonMedium,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MapingoColors.grey50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: const BorderSide(color: MapingoColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: const BorderSide(color: MapingoColors.error, width: 2),
      ),
      hintStyle: MapingoTypography.bodyMedium.copyWith(
        color: MapingoColors.grey400,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: MapingoColors.grey100,
      selectedColor: MapingoColors.primarySurface,
      disabledColor: MapingoColors.grey200,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusFull,
      ),
      labelStyle: MapingoTypography.labelMedium,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MapingoColors.white,
      selectedItemColor: MapingoColors.primary,
      unselectedItemColor: MapingoColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: MapingoTypography.labelSmall,
      unselectedLabelStyle: MapingoTypography.labelSmall,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: MapingoColors.grey900,
      contentTextStyle: MapingoTypography.bodyMedium.copyWith(
        color: MapingoColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusBase,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: MapingoColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusXl,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: MapingoColors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MapingoColors.primary,
      linearTrackColor: MapingoColors.grey200,
    ),
    dividerTheme: const DividerThemeData(
      color: MapingoColors.grey200,
      thickness: 1,
      space: 0,
    ),
  );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: MapingoColors.primaryLight,
      primaryContainer: MapingoColors.primaryDark,
      secondary: MapingoColors.secondaryLight,
      secondaryContainer: MapingoColors.secondaryDark,
      tertiary: MapingoColors.accentLight,
      error: MapingoColors.error,
      surface: MapingoColors.surfaceDark,
      onPrimary: MapingoColors.black,
      onSecondary: MapingoColors.black,
      onSurface: MapingoColors.grey100,
    ),
    scaffoldBackgroundColor: MapingoColors.backgroundDark,
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: AppBarTheme(
      backgroundColor: MapingoColors.grey900,
      foregroundColor: MapingoColors.grey100,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: MapingoTypography.headlineMedium.copyWith(
        color: MapingoColors.grey100,
      ),
    ),
    cardTheme: CardThemeData(
      color: MapingoColors.grey800,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusLg,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MapingoColors.primaryLight,
        foregroundColor: MapingoColors.black,
        disabledBackgroundColor: MapingoColors.grey700,
        disabledForegroundColor: MapingoColors.grey500,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusFull,
        ),
        textStyle: MapingoTypography.buttonLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: MapingoColors.primaryLight,
        disabledForegroundColor: MapingoColors.grey600,
        side: const BorderSide(color: MapingoColors.primaryLight, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusFull,
        ),
        textStyle: MapingoTypography.buttonLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: MapingoColors.primaryLight,
        disabledForegroundColor: MapingoColors.grey600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusBase,
        ),
        textStyle: MapingoTypography.buttonMedium,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MapingoColors.grey800,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: const BorderSide(color: MapingoColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadiusXl,
        borderSide: const BorderSide(color: MapingoColors.error, width: 2),
      ),
      hintStyle: MapingoTypography.bodyMedium.copyWith(
        color: MapingoColors.grey500,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: MapingoColors.grey800,
      selectedColor: MapingoColors.primaryDark,
      disabledColor: MapingoColors.grey700,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusFull,
      ),
      labelStyle: MapingoTypography.labelMedium,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MapingoColors.grey900,
      selectedItemColor: MapingoColors.primaryLight,
      unselectedItemColor: MapingoColors.grey500,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: MapingoTypography.labelSmall,
      unselectedLabelStyle: MapingoTypography.labelSmall,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: MapingoColors.grey100,
      contentTextStyle: MapingoTypography.bodyMedium.copyWith(
        color: MapingoColors.grey900,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusBase,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: MapingoColors.grey800,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusXl,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: MapingoColors.grey800,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: MapingoColors.primaryLight,
      linearTrackColor: MapingoColors.grey700,
    ),
    dividerTheme: DividerThemeData(
      color: MapingoColors.grey700,
      thickness: 1,
      space: 0,
    ),
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light
        ? MapingoColors.grey900
        : MapingoColors.grey100;

    final Color textColorMuted = brightness == Brightness.light
        ? MapingoColors.grey600
        : MapingoColors.grey400;

    return TextTheme(
      displayLarge: MapingoTypography.displayLarge.copyWith(color: textColor),
      displayMedium: MapingoTypography.displayMedium.copyWith(color: textColor),
      displaySmall: MapingoTypography.displaySmall.copyWith(color: textColor),
      headlineLarge: MapingoTypography.headlineLarge.copyWith(color: textColor),
      headlineMedium: MapingoTypography.headlineMedium.copyWith(color: textColor),
      headlineSmall: MapingoTypography.headlineSmall.copyWith(color: textColor),
      titleLarge: MapingoTypography.titleLarge.copyWith(color: textColor),
      titleMedium: MapingoTypography.titleMedium.copyWith(color: textColor),
      titleSmall: MapingoTypography.titleSmall.copyWith(color: textColor),
      bodyLarge: MapingoTypography.bodyLarge.copyWith(color: textColor),
      bodyMedium: MapingoTypography.bodyMedium.copyWith(color: textColor),
      bodySmall: MapingoTypography.bodySmall.copyWith(color: textColorMuted),
      labelLarge: MapingoTypography.labelLarge.copyWith(color: textColor),
      labelMedium: MapingoTypography.labelMedium.copyWith(color: textColor),
      labelSmall: MapingoTypography.labelSmall.copyWith(color: textColorMuted),
    );
  }
}
