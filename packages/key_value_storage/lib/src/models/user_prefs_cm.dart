import 'package:hive/hive.dart';

part 'user_prefs_cm.g.dart';

@HiveType(typeId: 3)
class UserPrefsCM extends HiveObject {
  @HiveField(0)
  String? translateFromLanguage;
  @HiveField(1)
  String? translateToLanguage;
  @HiveField(2)
  DarkModeCM darkMode;
  @HiveField(3)
  AppLanguageCM appLanguage;
  @HiveField(4)
  int fontSize;
  @HiveField(5)
  bool isPasteFromClipboard;

  UserPrefsCM({
    this.translateFromLanguage,
    this.translateToLanguage,
    this.darkMode = DarkModeCM.systemSettings,
    this.appLanguage = AppLanguageCM.english,
    this.fontSize = 16,
    this.isPasteFromClipboard = false,
  });

  UserPrefsCM copyWith({
    String? translateFromLanguage,
    String? translateToLanguage,
    DarkModeCM? darkMode,
    AppLanguageCM? appLanguage,
    int? fontSize,
    bool? isPasteFromClipboard,
  }) {
    return UserPrefsCM(
      translateFromLanguage:
          translateFromLanguage ?? this.translateFromLanguage,
      translateToLanguage: translateToLanguage ?? this.translateToLanguage,
      darkMode: darkMode ?? this.darkMode,
      appLanguage: appLanguage ?? this.appLanguage,
      fontSize: fontSize ?? this.fontSize,
      isPasteFromClipboard: isPasteFromClipboard ?? this.isPasteFromClipboard,
    );
  }
}

@HiveType(typeId: 4)
enum DarkModeCM {
  @HiveField(0)
  systemSettings,
  @HiveField(1)
  alwaysLight,
  @HiveField(2)
  alwaysDark,
}

@HiveType(typeId: 7)
enum AppLanguageCM {
  @HiveField(0)
  english,
  @HiveField(1)
  spanish,
  @HiveField(2)
  french,
  @HiveField(3)
  ukrainian,
  @HiveField(4)
  russian
}
