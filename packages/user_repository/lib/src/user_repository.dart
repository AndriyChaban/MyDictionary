import 'package:rxdart/rxdart.dart';

import 'package:key_value_storage/key_value_storage.dart';
import 'package:domain_models/domain_models.dart';

import './mappers/mappers.dart';

class UserRepository {
  final KeyValueStorage keyValueStorage;
  final BehaviorSubject<UserPrefsDM> _userPrefsSubject = BehaviorSubject();

  UserRepository({
    required this.keyValueStorage,
  });

  Future<void> upsertUserPrefs(UserPrefsDM userPrefs) async {
    final userPrefsBox = await keyValueStorage.getUserPrefsBox();
    final storedUserPrefs = userPrefsBox.get(0);
    final UserPrefsDM userPrefsNew;
    if (storedUserPrefs == null) {
      userPrefsNew = userPrefs;
    } else {
      userPrefsNew = userPrefs.copyWith(
          translateFromLanguage: storedUserPrefs.translateFromLanguage,
          translateToLanguage: storedUserPrefs.translateToLanguage);
    }
    userPrefsBox.put(0, userPrefsNew.toCache());
    _userPrefsSubject.add(userPrefsNew);
  }

  Stream<UserPrefsDM> getUserPreferences() async* {
    if (!_userPrefsSubject.hasValue) {
      final userPrefsBox = await keyValueStorage.getUserPrefsBox();
      final storedUserPrefs = userPrefsBox.get(0);
      _userPrefsSubject
          .add(storedUserPrefs?.toDomain() ?? UserPrefsCM().toDomain());
    }
    yield* _userPrefsSubject.stream;
  }

  Future<UserPrefsDM?> storedUserPreferences() async {
    final userPrefsBox = await keyValueStorage.getUserPrefsBox();
    final storedUserPrefs = userPrefsBox.get(0);
    return storedUserPrefs?.toDomain();
  }

  // get _userPrefsBox  => keyValueStorage.getUserPrefsBox();

  Future<String?> get getFromLanguage async {
    return (await keyValueStorage.getUserPrefsBox())
        .get(0)
        ?.translateFromLanguage;
  }

  Future<String?> get getToLanguage async {
    return (await keyValueStorage.getUserPrefsBox())
        .get(0)
        ?.translateToLanguage;
  }

  void saveFromLanguage(String? from) async {
    final userPrefsBox = await keyValueStorage.getUserPrefsBox();
    final userPrefs = userPrefsBox.get(0);
    if (userPrefs == null) {
      userPrefsBox.put(0, UserPrefsCM()..translateFromLanguage = from);
    } else {
      userPrefs.translateFromLanguage = from;
      userPrefs.save();
    }
  }

  void saveToLanguage(String? to) async {
    final userPrefsBox = await keyValueStorage.getUserPrefsBox();
    final userPrefs = userPrefsBox.get(0);
    if (userPrefs == null) {
      userPrefsBox.put(0, UserPrefsCM()..translateToLanguage = to);
    } else {
      userPrefs.translateToLanguage = to;
      userPrefs.save();
    }
  }
}
