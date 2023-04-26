import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:domain_models/domain_models.dart';
import 'package:user_repository/user_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UserRepository userRepository;
  SettingsCubit({
    required this.userRepository,
  }) : super(const SettingsStateInitial());

  void initializeSettingsCubit() async {
    final userPrefs = await userRepository.storedUserPreferences();
    emit(SettingsState(
        appLanguage: userPrefs?.appLanguage ?? AppLanguageDM.english,
        fontSize: userPrefs?.fontSize ?? 15,
        darkMode: userPrefs?.darkMode ?? DarkModeDM.systemSettings,
        isPasteFromClipboard: userPrefs?.isPasteFromClipboard ?? false));
  }

  void changeAppLanguage(AppLanguageDM appLanguage) {
    if (appLanguage != state.appLanguage) {
      emit(state.copyWith(appLanguage: appLanguage));
      _updateUserPrefs();
    }
  }

  void changeFontSize(int fontSize) {
    if (state.fontSize != fontSize) {
      emit(state.copyWith(fontSize: fontSize));
      _updateUserPrefs();
    }
  }

  void changeDarkMode(DarkModeDM darkMode) {
    if (state.darkMode != darkMode) {
      emit(state.copyWith(darkMode: darkMode));
      _updateUserPrefs();
    }
  }

  void changeIsPasteFromClipboard(bool isPasteFromClipboard) {
    if (state.isPasteFromClipboard != isPasteFromClipboard) {
      emit(state.copyWith(isPasteFromClipboard: isPasteFromClipboard));
      _updateUserPrefs();
    }
  }

  void _updateUserPrefs() {
    userRepository.upsertUserPrefs(UserPrefsDM(
        fontSize: state.fontSize,
        darkMode: state.darkMode,
        appLanguage: state.appLanguage,
        isPasteFromClipboard: state.isPasteFromClipboard));
  }
}
