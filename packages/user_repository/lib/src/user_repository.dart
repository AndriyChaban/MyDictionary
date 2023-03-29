import 'package:key_value_storage/key_value_storage.dart';

class UserRepository {
  final KeyValueStorage keyValueStorage;

  const UserRepository({
    required this.keyValueStorage,
  });

  get userPrefsBox async => await keyValueStorage.getUserPrefsBox();

  Future<String?> get getFromLanguage async {
    return (await keyValueStorage.getUserPrefsBox())
        .get('translateFromLanguage');
  }

  Future<String?> get getToLanguage async {
    return (await keyValueStorage.getUserPrefsBox()).get('translateToLanguage');
  }

  void saveFromLanguage(String? from) async {
    (await keyValueStorage.getUserPrefsBox())
        .put('translateFromLanguage', from);
  }

  void saveToLanguage(String? to) async {
    (await keyValueStorage.getUserPrefsBox()).put('translateToLanguage', to);
  }
}
