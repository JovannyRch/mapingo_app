import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';

class SettingsLocalDatasource {
  static const _soundEffectsKey = 'mapingo.sound_effects_enabled';
  static const _hapticFeedbackKey = 'mapingo.haptic_feedback_enabled';
  static const _themeModeKey = 'mapingo.theme_mode';
  static const _localeKey = 'mapingo.locale';

  final SharedPreferences _preferences;

  const SettingsLocalDatasource(this._preferences);

  Future<SettingsModel> fetchSettings() async {
    final themeModeIndex = _preferences.getInt(_themeModeKey) ?? 0;
    final localeCode = _preferences.getString(_localeKey) ?? 'en';
    return SettingsModel(
      soundEffectsEnabled: _preferences.getBool(_soundEffectsKey) ?? true,
      hapticFeedbackEnabled: _preferences.getBool(_hapticFeedbackKey) ?? true,
      themeMode: ThemeMode.values[themeModeIndex],
      locale: Locale(localeCode),
    );
  }

  Future<SettingsModel> setSoundEffectsEnabled(bool enabled) async {
    await _preferences.setBool(_soundEffectsKey, enabled);
    return fetchSettings();
  }

  Future<SettingsModel> setHapticFeedbackEnabled(bool enabled) async {
    await _preferences.setBool(_hapticFeedbackKey, enabled);
    return fetchSettings();
  }

  Future<SettingsModel> setThemeMode(ThemeMode mode) async {
    await _preferences.setInt(_themeModeKey, mode.index);
    return fetchSettings();
  }

  Future<SettingsModel> setLocale(Locale locale) async {
    await _preferences.setString(_localeKey, locale.languageCode);
    return fetchSettings();
  }

  Future<SettingsModel> resetLocalCache() async {
    await _preferences.remove(_soundEffectsKey);
    await _preferences.remove(_hapticFeedbackKey);
    await _preferences.remove(_themeModeKey);
    await _preferences.remove(_localeKey);
    return fetchSettings();
  }
}
