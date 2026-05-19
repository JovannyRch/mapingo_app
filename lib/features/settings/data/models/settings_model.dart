import 'package:flutter/material.dart';

class SettingsModel {
  final bool soundEffectsEnabled;
  final bool hapticFeedbackEnabled;
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsModel({
    required this.soundEffectsEnabled,
    required this.hapticFeedbackEnabled,
    required this.themeMode,
    required this.locale,
  });

  const SettingsModel.defaults()
      : soundEffectsEnabled = true,
        hapticFeedbackEnabled = true,
        themeMode = ThemeMode.system,
        locale = const Locale('en');

  SettingsModel copyWith({
    bool? soundEffectsEnabled,
    bool? hapticFeedbackEnabled,
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsModel(
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
