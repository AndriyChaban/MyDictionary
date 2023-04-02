import 'package:hive/hive.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:key_value_storage/src/models/dictionary_cm.dart';
import 'package:key_value_storage/src/models/wizz_deck_cm.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'models/history_cm.dart';

class KeyValueStorage {
  static const _dictionariesBoxKey = 'dictionaries';
  static const _wizzDecksBoxKey = 'wizz-decks';
  static const _userPrefsBoxKey = 'user-prefs';
  static const _historyDictionariesBoxKey = 'history-dictionaries';

  late String _hiveDirectory;

  KeyValueStorage() {
    _initHive();
  }
  void _initHive() async {
    _hiveDirectory =
        join((await getApplicationDocumentsDirectory()).path, 'hiveDirectory');
    Hive
      ..init(_hiveDirectory)
      ..registerAdapter(DictionaryCMAdapter())
      ..registerAdapter(WizzDeckCMAdapter())
      ..registerAdapter(WizzCardCMAdapter())
      ..registerAdapter(DarkModeCMAdapter())
      ..registerAdapter(HistoryDictionaryCMAdapter())
      ..registerAdapter(HistoryCardCMAdapter());
  }

  Future<Box<DictionaryCM>> getDictionariesBox() =>
      _openHiveBox<DictionaryCM>(_dictionariesBoxKey);
  Future<Box<WizzDeckCM>> getWizzDecksBox() =>
      _openHiveBox<WizzDeckCM>(_wizzDecksBoxKey);
  Future<Box<String?>> getUserPrefsBox() =>
      _openHiveBox<String?>(_userPrefsBoxKey);
  Future<Box<HistoryDictionaryCM>> getHistoryDictionariesBox() =>
      _openHiveBox<HistoryDictionaryCM>(_historyDictionariesBoxKey);

  Future<Box<T>> _openHiveBox<T>(String boxKey) async {
    if (Hive.isBoxOpen(boxKey)) {
      return Hive.box(boxKey);
    } else {
      return Hive.openBox<T>(
        boxKey,
        path: _hiveDirectory,
      );
    }
  }
}
