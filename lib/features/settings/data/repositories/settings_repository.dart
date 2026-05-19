import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepository {
  final SettingsLocalDatasource _datasource;

  const SettingsRepository(this._datasource);

  Future<SettingsModel> fetchSettings() {
    return _datasource.fetchSettings();
  }

  Future<SettingsModel> setSoundEffectsEnabled(bool enabled) {
    return _datasource.setSoundEffectsEnabled(enabled);
  }

  Future<SettingsModel> setHapticFeedbackEnabled(bool enabled) {
    return _datasource.setHapticFeedbackEnabled(enabled);
  }

  Future<SettingsModel> resetLocalCache() {
    return _datasource.resetLocalCache();
  }
}
