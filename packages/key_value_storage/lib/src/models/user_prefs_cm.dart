import 'package:hive/hive.dart';

part 'user_prefs_cm.g.dart';

@HiveType(typeId: 3)
class UserPrefsCM extends HiveObject {
  @HiveField(0)
  final String? translateFromLanguage = null;
  @HiveField(1)
  final String? translateToLanguage = null;
  @HiveField(2)
  final DarkModeCM darkMode = DarkModeCM.systemSettings;


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
