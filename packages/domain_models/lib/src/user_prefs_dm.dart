import 'package:equatable/equatable.dart';

class UserPrefsDM extends Equatable {
  final String? translateFromLanguage;
  final String? translateToLanguage;
  final int fontSize;
  final DarkModeDM darkMode;
  final AppLanguageDM appLanguage;
  final bool isPasteFromClipboard;

  const UserPrefsDM({
    this.translateFromLanguage,
    this.translateToLanguage,
    required this.fontSize,
    required this.darkMode,
    required this.appLanguage,
    required this.isPasteFromClipboard,
  });

  @override
  List<Object?> get props => [
        translateFromLanguage,
        translateToLanguage,
        fontSize,
        darkMode,
        appLanguage,
        isPasteFromClipboard,
      ];

  UserPrefsDM copyWith({
    String? translateFromLanguage,
    String? translateToLanguage,
    int? fontSize,
    DarkModeDM? darkMode,
    AppLanguageDM? appLanguage,
    bool? isPasteFromClipboard,
  }) {
    return UserPrefsDM(
      translateFromLanguage:
          translateFromLanguage ?? this.translateFromLanguage,
      translateToLanguage: translateToLanguage ?? this.translateToLanguage,
      fontSize: fontSize ?? this.fontSize,
      darkMode: darkMode ?? this.darkMode,
      appLanguage: appLanguage ?? this.appLanguage,
      isPasteFromClipboard: isPasteFromClipboard ?? this.isPasteFromClipboard,
    );
  }
}

enum DarkModeDM {
  systemSettings,
  alwaysLight,
  alwaysDark,
}

enum AppLanguageDM { english, spanish, french, ukrainian, russian }
