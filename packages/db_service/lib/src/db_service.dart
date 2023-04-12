import 'dart:io';
import 'dart:isolate';

import 'package:db_service/src/models/card_db.dart';
import 'package:isar/isar.dart';
import '../db_service.dart';

class DBService {
  // void firstInitOfDB(String dictName) async {
  //   dictName = dictName.replaceAll(' ', '_');
  //   // final instance = await Mimir.defaultInstance;
  //   // final index = instance.getIndex(dictName);
  // }

  //TODO open instances of active working databases on start

  //TODO close instances if not needed
  void closeInstance({required String dictionaryName}) {
    final isar = Isar.getInstance(dictionaryName);
    isar?.close();
  }

  Future<bool> createDictionary(
      DictionaryDB dictionary, String directoryDictionaryDB) async {
    try {
      // final isar = getDictionaryInstance(
      //     dictionaryName: dictionary.dictionaryName,
      //     directory: directoryDictionaryDB)!;

      final fileExists =
          File('$directoryDictionaryDB/${dictionary.dictionaryName}.isar')
              .existsSync();

      await Isolate.run(() {
        final isar = getDictionaryInstance(
            dictionaryName: dictionary.dictionaryName,
            directory: directoryDictionaryDB)!;
        if (fileExists) {
          // print('clearing database');
          // isar;
          isar.writeTxnSync(() async => isar.cards.clearSync());
        }

        // print('writing database');
        isar.writeTxnSync<Card?>(() {
          for (CardDB wordCard in dictionary.cardsList) {
            final card = Card()
              ..headword = wordCard.headword
              ..fullCardText = wordCard.text;
            isar.cards.putSync(card);
          }
        });
        // print('writing finished');
        isar.close();
      });
    } on IsarError {
      rethrow;
    }
    return true;
  }

  void deleteDictionary(DictionaryDB dictionary, String directoryPath) {
    try {
      final isar = getDictionaryInstance(
          dictionaryName: dictionary.dictionaryName, directory: directoryPath);

      isar?.clearSync();
      // TODO remove database files from memory ???
    } catch (e) {
      rethrow;
    }
  }

  Isar? getDictionaryInstance(
      {required String dictionaryName, required String directory}) {
    try {
      return Isar.openSync([CardSchema],
          name: dictionaryName, directory: directory, inspector: true);
    } on IsarError {
      return Isar.getInstance(dictionaryName);
    }
  }

  // void _createDictionaryIsolateFunction(
  //     {required String dictionaryName, required String directory}) async {
  //   final isar = getDictionaryInstance(
  //       dictionaryName: dictionaryName, directory: directory);
  //   isar?.close();
  // }
}
