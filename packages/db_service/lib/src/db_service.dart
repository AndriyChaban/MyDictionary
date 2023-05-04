import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

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
  void closeIsarInstance({required String dictionaryName}) {
    final isar = Isar.getInstance(dictionaryName);
    isar?.close();
  }

  Future<bool> createIsarDictionary(
      DictionaryDB dictionary, String directoryDictionaryDB) async {
    try {
      // final isar = getDictionaryInstance(
      //     dictionaryName: dictionary.dictionaryName,
      //     directory: directoryDictionaryDB)!;

      final fileExists =
          File('$directoryDictionaryDB/${dictionary.dictionaryName}.isar')
              .existsSync();

      await Isolate.run(() {
        final isar = getIsarDictionaryInstance(
            dictionaryName: dictionary.dictionaryName,
            directory: directoryDictionaryDB)!;
        if (fileExists) {
          // print('clearing database');
          // isar;
          isar.writeTxnSync(() => isar.cardIsars.clearSync());
        }

        // print('writing database');
        final _ = isar.writeTxnSync<CardIsar?>(() {
          for (CardDB wordCard in dictionary.cardsList) {
            final card = CardIsar()
              ..headword = wordCard.headword
              ..fullCardText = wordCard.text;
            isar.cardIsars.putSync(card);
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

  Future<void> createIsarConjugationForms(
      {required String language,
      required String directory,
      required String wordReversedLookup,
      required String wordFormsLookup}) async {
    final fileExists =
        File('$directory/${language}_forms_reversed.isar').existsSync();
    if (!fileExists || fileExists) {
      await Isolate.run(() {
        final isar = getIsarReversedLookupInstance(
            dictionaryName: '${language}_forms_reversed',
            directory: directory)!;
        final wordReversedLookupJson = jsonDecode(wordReversedLookup);
        final wordFormLookupJson = jsonDecode(wordReversedLookup);
        isar.writeTxnSync<WordFormLookupReversedIsar?>(() {
          for (var wordForm in wordReversedLookupJson.entries) {
            final WordFormLookupReversedIsar wordFormIsar =
                WordFormLookupReversedIsar()
                  ..wordForm = wordForm.key
                  ..infinitive = wordForm.value['infinitive'];
            isar.wordFormLookupReversedIsars.putSync(wordFormIsar);
          }
        });
      });
    }
  }

  void deleteIsarDictionary(DictionaryDB dictionary, String directoryPath) {
    try {
      final isar = getIsarDictionaryInstance(
          dictionaryName: dictionary.dictionaryName, directory: directoryPath);
      isar?.writeTxnSync(() => isar.clearSync());
      // isar?.clearSync();
      // TODO remove database files from memory ???
    } catch (e) {
      rethrow;
    }
  }

  Isar? getIsarDictionaryInstance(
      {required String dictionaryName, required String directory}) {
    try {
      return Isar.openSync([CardIsarSchema],
          name: dictionaryName, directory: directory, inspector: true);
    } on IsarError {
      return Isar.getInstance(dictionaryName);
    }
  }

  Isar? getIsarReversedLookupInstance(
      {required String dictionaryName, required String directory}) {
    try {
      return Isar.openSync([WordFormLookupReversedIsarSchema],
          name: dictionaryName, directory: directory, inspector: true);
    } on IsarError {
      return Isar.getInstance(dictionaryName);
    }
  }

  // Future<MimirIndex> getMimirDictionaryIndex(
  //     {required String dictionaryName, required String directory}) async {
  //   // try {
  //   final instance = await Mimir.getInstanceForPath(directory);
  //   // final instance =
  //   //     Mimir.getInstance(path: directory, library: createLibraryImpl());
  //   final index = instance.getIndex(dictionaryName);
  //   return index;
  //
  //   // } catch(e) {
  //   // }
  // }
  //
  // Future<bool> createMimirDictionary(
  //     DictionaryDB dictionary, String directoryDictionaryDB) async {
  //   try {
  //     final fileExists =
  //         File('$directoryDictionaryDB/${dictionary.dictionaryName}.isar')
  //             .existsSync();
  //
  //     // await Isolate.run(() async {
  //     // BackgroundIsolateBinaryMessenger.ensureInitialized();
  //     final mimirIndex = await getMimirDictionaryIndex(
  //         dictionaryName: dictionary.dictionaryName,
  //         directory: directoryDictionaryDB);
  //     if (fileExists) {
  //       mimirIndex.deleteAllDocuments();
  //     }
  //
  //     // final _ = isar.writeTxnSync<Card?>(() {
  //     //   for (CardDB wordCard in dictionary.cardsList) {
  //     //     final card = Card()
  //     //       ..headword = wordCard.headword
  //     //       ..fullCardText = wordCard.text;
  //     //     isar.cards.putSync(card);
  //     //   }
  //     // });
  //     for (CardDB wordCard in dictionary.cardsList) {
  //       final card =
  //           CardMimir(id: wordCard.headword!, fullText: wordCard.text!);
  //       mimirIndex.addDocument({wordCard.headword!: card});
  //     }
  //     mimirIndex.close();
  //     // });
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  //   return true;
  // }
  //
  // void deleteMimirDictionary(
  //     DictionaryDB dictionary, String directoryPath) async {
  //   final mimirIndex = await getMimirDictionaryIndex(
  //       dictionaryName: dictionary.dictionaryName, directory: directoryPath);
  //   mimirIndex.deleteAllDocuments();
  // }
}
