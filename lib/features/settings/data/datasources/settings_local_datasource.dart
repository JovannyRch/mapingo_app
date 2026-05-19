import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';

class SettingsLocalDatasource {
  static const _soundEffectsKey = 'mapingo.sound_effects_enabled';
  static const _hapticFeedbackKey = 'mapingo.haptic_feedback_enabled';

  final SharedPreferences _preferences;

  const SettingsLocalDatasource(this._preferences);

  Future<SettingsModel> fetchSettings() async {
    return SettingsModel(
      soundEffectsEnabled: _preferences.getBool(_soundEffectsKey) ?? true,
      hapticFeedbackEnabled: _preferences.getBool(_hapticFeedbackKey) ?? true,
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

  Future<SettingsModel> resetLocalCache() async {
    await _preferences.remove(_soundEffectsKey);
    await _preferences.remove(_hapticFeedbackKey);
    return fetchSettings();
  }
}
