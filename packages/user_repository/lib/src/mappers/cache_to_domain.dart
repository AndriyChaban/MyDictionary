import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension UserPrefsCacheToDomain on UserPrefsCM {
  UserPrefsDM toDomain() => UserPrefsDM(
      translateFromLanguage: translateFromLanguage,
      translateToLanguage: translateToLanguage,
      fontSize: fontSize,
      darkMode: darkMode.toDomain(),
      appLanguage: appLanguage.toDomain(),
      isPasteFromClipboard: isPasteFromClipboard);
}

extension DarkModeCacheToDomain on DarkModeCM {
  DarkModeDM toDomain() {
    switch (this) {
      case DarkModeCM.systemSettings:
        return DarkModeDM.systemSettings;
      case DarkModeCM.alwaysLight:
        return DarkModeDM.alwaysLight;
      case DarkModeCM.alwaysDark:
        return DarkModeDM.alwaysDark;
    }
  }
}

extension AppLanguageCacheToDomain on AppLanguageCM {
  AppLanguageDM toDomain() {
    switch (this) {
      case AppLanguageCM.english:
        return AppLanguageDM.english;
      case AppLanguageCM.spanish:
        return AppLanguageDM.spanish;
      case AppLanguageCM.french:
        return AppLanguageDM.french;
      case AppLanguageCM.ukrainian:
        return AppLanguageDM.ukrainian;
      case AppLanguageCM.russian:
        return AppLanguageDM.russian;
    }
  }
}

// extension ShowFrequencyCMtoDM on ShowFrequencyCM {
//   ShowFrequencyDM toDomain() {
//     switch (this) {
//       case ShowFrequencyCM.low:
//         return ShowFrequencyDM.low;
//       case ShowFrequencyCM.normal:
//         return ShowFrequencyDM.normal;
//       case ShowFrequencyCM.high:
//         return ShowFrequencyDM.high;
//     }
//   }
// }
