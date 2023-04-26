import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension UserPrefsDomainToCache on UserPrefsDM {
  UserPrefsCM toCache() => UserPrefsCM(
      translateFromLanguage: translateFromLanguage,
      translateToLanguage: translateToLanguage,
      fontSize: fontSize,
      darkMode: darkMode.toCache(),
      appLanguage: appLanguage.toCache(),
      isPasteFromClipboard: isPasteFromClipboard);
}

extension DarkModeDomainToCache on DarkModeDM {
  DarkModeCM toCache() {
    switch (this) {
      case DarkModeDM.systemSettings:
        return DarkModeCM.systemSettings;
      case DarkModeDM.alwaysLight:
        return DarkModeCM.alwaysLight;
      case DarkModeDM.alwaysDark:
        return DarkModeCM.alwaysDark;
    }
  }
}

extension AppLanguageDomainToCache on AppLanguageDM {
  AppLanguageCM toCache() {
    switch (this) {
      case AppLanguageDM.english:
        return AppLanguageCM.english;
      case AppLanguageDM.spanish:
        return AppLanguageCM.spanish;
      case AppLanguageDM.french:
        return AppLanguageCM.french;
      case AppLanguageDM.ukrainian:
        return AppLanguageCM.ukrainian;
      case AppLanguageDM.russian:
        return AppLanguageCM.russian;
    }
  }
}
