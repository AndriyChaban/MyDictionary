part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final int fontSize;
  final AppLanguageDM appLanguage;
  final bool isPasteFromClipboard;
  final DarkModeDM darkMode;

  const SettingsState({
    required this.fontSize,
    required this.appLanguage,
    required this.isPasteFromClipboard,
    required this.darkMode,
  });

  @override
  List<Object> get props => [
        fontSize,
        appLanguage,
        isPasteFromClipboard,
        darkMode,
      ];

  SettingsState copyWith({
    int? fontSize,
    AppLanguageDM? appLanguage,
    bool? isPasteFromClipboard,
    DarkModeDM? darkMode,
  }) {
    return SettingsState(
      fontSize: fontSize ?? this.fontSize,
      appLanguage: appLanguage ?? this.appLanguage,
      isPasteFromClipboard: isPasteFromClipboard ?? this.isPasteFromClipboard,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

class SettingsStateInitial extends SettingsState {
  const SettingsStateInitial()
      : super(
            fontSize: 15,
            darkMode: DarkModeDM.systemSettings,
            appLanguage: AppLanguageDM.english,
            isPasteFromClipboard: false);
}
