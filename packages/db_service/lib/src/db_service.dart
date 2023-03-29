import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as path;

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

  bool createDictionary(DictionaryDB dictionary, String directoryDictionaryDB) {
    try {
      // await Isar.initializeIsarCore();
      // final dictionary = input[0];
      // final directoryDictionaryDB = input[1];
      // final isar = Isar.openSync([CardSchema],
      //     name: dictionary.dictionaryName, directory: directoryDictionaryDB);
      final isar = getDictionaryInstance(
          dictionaryName: dictionary.dictionaryName,
          directory: directoryDictionaryDB)!;
      // if (File('$directoryDictionaryDB/${dictionary.dictionaryName}.isar')
      //     .existsSync()) {
      //   print('clearing database');
      //   isar.writeTxnSync(() async => isar.cards.clearSync());
      // }
      // print('writing database');
      // isar.writeTxnSync<Card?>(() {
      //   for (CardDB wordCard in dictionary.cardsList) {
      //     final card = Card()
      //       ..headword = wordCard.headword
      //       ..fullCardText = wordCard.text;
      //     isar.cards.putSync(card);
      //   }
      // });
      final fileExists =
          File('$directoryDictionaryDB/${dictionary.dictionaryName}.isar')
              .existsSync();
      // final receivePort = ReceivePort();
      // await Isolate.spawn((message) { }, message)
      Isolate.run(() {
        final isar = getDictionaryInstance(
            dictionaryName: dictionary.dictionaryName,
            directory: directoryDictionaryDB)!;
        if (fileExists) {
          print('clearing database');
          isar;
          isar.writeTxnSync(() async => isar.cards.clearSync());
        }
        print('writing database');
        isar.writeTxnSync<Card?>(() {
          for (CardDB wordCard in dictionary.cardsList) {
            final card = Card()
              ..headword = wordCard.headword
              ..fullCardText = wordCard.text;
            isar.cards.putSync(card);
          }
        });
        isar.close();
      });
    } on IsarError catch (e) {
      // print(e);
      rethrow;
    }
    return true;
  }

  void deleteDictionary(DictionaryDB dictionary, String directoryPath) {
    try {
      final isar = getDictionaryInstance(
          dictionaryName: dictionary.dictionaryName, directory: directoryPath);
      isar?.clearSync();
      // TODO remove database files from memory
    } catch (e) {
      rethrow;
    }
  }

  Isar? getDictionaryInstance(
      {required String dictionaryName, required String directory}) {
    try {
      return Isar.openSync([CardSchema],
          name: dictionaryName, directory: directory);
    } on IsarError catch (error) {
      return Isar.getInstance(dictionaryName);
    }
  }

  void _createDictionaryIsolateFunction(
      {required String dictionaryName, required String directory}) async {
    final isar = getDictionaryInstance(
        dictionaryName: dictionaryName, directory: directory);
    isar?.close();
  }
}
