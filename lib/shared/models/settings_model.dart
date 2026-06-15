class SettingsState {
  final String calculationMethod;
  final bool notificationsEnabled;

  const SettingsState({
    required this.calculationMethod,
    required this.notificationsEnabled,
  });

  const SettingsState.defaults()
      : calculationMethod = 'MWL',
        notificationsEnabled = false;

  SettingsState copyWith({
    String? calculationMethod,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      calculationMethod: calculationMethod ?? this.calculationMethod,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
