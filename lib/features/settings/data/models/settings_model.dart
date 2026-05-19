class SettingsModel {
  final bool soundEffectsEnabled;
  final bool hapticFeedbackEnabled;

  const SettingsModel({
    required this.soundEffectsEnabled,
    required this.hapticFeedbackEnabled,
  });

  const SettingsModel.defaults()
    : soundEffectsEnabled = true,
      hapticFeedbackEnabled = true;

  SettingsModel copyWith({
    bool? soundEffectsEnabled,
    bool? hapticFeedbackEnabled,
  }) {
    return SettingsModel(
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
    );
  }
}
