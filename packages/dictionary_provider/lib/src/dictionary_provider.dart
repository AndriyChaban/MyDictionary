import 'dart:io';
// import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:db_service/db_service.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/services.dart';
import 'package:google_api_service/google_api_service.dart';
import 'package:isar/isar.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:path_provider/path_provider.dart';
import './mappers/mappers.dart';

class DictionaryProvider {
  late final KeyValueStorage keyValueStorage;
  late final DBService dbService;
  late final GoogleAPIService googleApiService;

  late Directory dictionaryDSLDirectory;
  late Directory dictionaryDBDirectory;
  // String? currentDictionary;

  DictionaryProvider._initializeProvider() {
    // for each active dict in keyValueStorage, based on current language,
    // get instances
  }

  static Future<DictionaryProvider> initializeProvider(
      {required KeyValueStorage keyValueStorage,
      required DBService dbService,
      required GoogleAPIService googleApiService}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dictionaryDBDirectory = Directory(join(appDir.path, 'dictsDB'));
    final dictionaryDSLDirectory = Directory(join(appDir.path, 'dictsDSL'));
    if (!dictionaryDSLDirectory.existsSync()) dictionaryDSLDirectory.create();
    if (!dictionaryDBDirectory.existsSync()) dictionaryDBDirectory.create();
    return DictionaryProvider._initializeProvider()
      ..dictionaryDSLDirectory = dictionaryDSLDirectory
      ..dictionaryDBDirectory = dictionaryDBDirectory
      ..keyValueStorage = keyValueStorage
      ..dbService = dbService
      ..googleApiService = googleApiService;
  }

  Future<bool> createDictionary(String filePath) async {
    // print(filePath);
    final dictBox = await keyValueStorage.getDictionariesBox();
    // TODO copy file from local storage
    final copiedFilePath =
        await _copyFromToDictDirectory(filePath, fromAsset: true);
    // final copiedFilePath = await _copyFromAssetsToDictDirectory(filePath);
    // parse copied file into DictionaryDM
    print('start parsing');
    final parsedDictionary = await compute(_parseDslDictionary, copiedFilePath);
    // if (dictBox.containsKey(parsedDictionary.name)) {
    //   print('WTF???');
    //   return false;
    // }
    // create DB
    try {
      // compute(
      //   dbService.createDictionary, [ parsedDictionary.toDBModel(), dictionaryDBDirectory.path]
      // );
      print('start creating DB');
      await dbService.createDictionary(
          parsedDictionary.toDBModel(), dictionaryDBDirectory.path);
      //TODO delete dsl after successful parsing???
      // File(copiedFilePath).deleteSync();
      // update keyValueStorage
      await dictBox.put(parsedDictionary.name,
          parsedDictionary.toCacheModel()..active = true);
      return true;
    } catch (e) {
      throw DatabaseException();
    }
  }

  Future<void> deleteDictionary(DictionaryDM dictionary) async {
    try {
      final dictBox = await keyValueStorage.getDictionariesBox();
      if (!dictBox.containsKey(dictionary.name))
        throw DictionaryKeyDoesNotExistException();
      dbService.deleteDictionary(
          dictionary.toDBModel(), dictionaryDBDirectory.path);
      await dictBox.delete(dictionary.name);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> openDictionary(String dictionaryName) async {
    // check if it exists in keyValueStorage and DB
    //
  }

  Future<List<DictionaryDM>> getAllDictionariesWordTranslation(
      {required String word,
      required String translateFrom,
      required String translateTo,
      bool startsWith = true}) async {
    List<DictionaryDM> results = [];
    for (final dict in await _listOfActiveDictionaries) {
      // print(dict);
      if (dict.indexLanguage.toLowerCase() == translateFrom &&
          dict.contentLanguage.toLowerCase() == translateTo) {
        results.add(dict.copyWith(
            cards: (await _getSingleDictionaryWordTranslations(dict.name, word,
                startsWith: startsWith))));
      }
    }
    return results.where((d) => d.cards.isNotEmpty).toList();
  }

  Future<List<DictionaryDM>> get _listOfActiveDictionaries async {
    final dictionariesBox = await keyValueStorage.getDictionariesBox();
    print(dictionariesBox.values.first.active);
    return dictionariesBox.values
        .where((dict) => dict.active == true)
        .map((dict) => dict.toDomainModel())
        .toList();
  }

  Future<List<DictionaryDM>> get listOfAllDictionaries async {
    final dictionariesBox = await keyValueStorage.getDictionariesBox();
    return dictionariesBox.values.map((dict) => dict.toDomainModel()).toList();
  }

  List<CardDM> _getSingleDictionaryWordTranslations(
      String dictionaryName, String word,
      {bool startsWith = true}) {
    final dictionaryInstance = dbService.getDictionaryInstance(
        dictionaryName: dictionaryName, directory: dictionaryDBDirectory.path);
    if (dictionaryInstance == null) throw DictionaryDBDoesNotExistException();
    final queryStart = dictionaryInstance.cards.filter();
    final queryFinal = startsWith
        ? queryStart.headwordStartsWith(word, caseSensitive: false)
        : queryStart.headwordEqualTo(word, caseSensitive: true);
    final cards = queryFinal.offset(0).limit(30).findAllSync();
    return cards
        .where((card) => card.headword != null && card.fullCardText != null)
        .map((card) => card.toDomainModel())
        .toList();
  }

  void addCardToHistory(
      {required CardDM card,
      required String fromLanguage,
      required String toLanguage,
      required String dictionaryName}) async {
    final historyBox = await keyValueStorage.getHistoryDictionariesBox();
    final historyDict = historyBox.get('$fromLanguage-$toLanguage');
    final newCard = HistoryCardCM(
        headword: card.headword,
        text: card.text,
        dictionaryName: dictionaryName);
    if (historyDict != null) {
      historyDict.cards = historyDict.cards
          .where((c) => c.headword != card.headword)
          .take(50)
          .toList()
        ..add(newCard);
      historyDict.save();
    } else {
      historyBox.put(
          '$fromLanguage-$toLanguage',
          HistoryDictionaryCM(
              languageFrom: fromLanguage,
              languageTo: toLanguage,
              cards: [newCard]));
    }
  }

  Future<List<CardDM>> getHistoryCards(
      {required String fromLanguage, required String toLanguage}) async {
    final historyBox = await keyValueStorage.getHistoryDictionariesBox();
    final historyDict = historyBox.get('$fromLanguage-$toLanguage');
    if (historyDict == null) return [];
    return historyDict.cards.map((c) => c.toDomainModel()).toList();
  }

  Future<String> _copyFromToDictDirectory(String filePath,
      {bool fromAsset = false}) async {
    String fileString;
    // if (!force && !File(filePath).existsSync())
    //   throw DictionaryExistsException();
    if (fromAsset) {
      final fileRaw = await rootBundle.load(filePath);
      fileString = String.fromCharCodes(fileRaw.buffer.asUint16List());
    } else {
      fileString = await File(filePath).readAsString();
    }
    // print(fileString.substring(0, 30));
    final nameRegexp = RegExp(r'^#name(.*)$',
        multiLine: true, dotAll: false, caseSensitive: false);
    String? name;
    if (fromAsset) {
      name = basenameWithoutExtension(filePath);
    } else {
      name = nameRegexp.firstMatch(fileString)?.group(1)?.trim();
    }
    final copiedFilePath = join(dictionaryDSLDirectory.path, '$name.dsl');
    final newFile = File(copiedFilePath);
    newFile.writeAsStringSync(fileString);
    return copiedFilePath;
  }

  DictionaryDM _parseDslDictionary(String filePath) {
    /// replace: " &quot
    ///           ' &apos
    ///           & &amp
    ///           < &lt
    ///           > &gt

    // replace [] with <>
    // replace [c gray] <gray>
    // [c] <green>

    final dictFile = File(filePath).readAsStringSync();
    final nameRegexp = RegExp(r'^#name(.*)$',
        multiLine: true, dotAll: false, caseSensitive: false);
    final indexLanguageRegexp = RegExp(r'^#INDEX_LANGUAGE(.*)$',
        multiLine: true, dotAll: false, caseSensitive: false);
    final contentsLanguageRegexp = RegExp(r'^#CONTENTS_LANGUAGE(.*)$',
        multiLine: true, dotAll: false, caseSensitive: false);
    final cardRegExp = RegExp(r'(^[^\s#].*?)(^\t(.|\n)+?)(?=(^\S))',
        dotAll: true, multiLine: true, unicode: true);
    final firstWordRegExp = RegExp(r'[A-Z].*?(?![^A-Z])');
    final name =
        nameRegexp.firstMatch(dictFile)?.group(1)?.trim().replaceAll('"', '');
    final indexLanguageRaw = indexLanguageRegexp
        .firstMatch(dictFile)
        ?.group(1)
        ?.trim()
        .replaceAll('"', '');
    String? indexLanguage = null;
    String? contentsLanguage = null;
    final contentsLanguageRaw = contentsLanguageRegexp
        .firstMatch(dictFile)
        ?.group(1)
        ?.trim()
        .replaceAll('"', '');
    if (indexLanguageRaw != null) {
      indexLanguage =
          firstWordRegExp.firstMatch(indexLanguageRaw)?.group(0)?.toLowerCase();
    }
    if (contentsLanguageRaw != null)
      contentsLanguage = firstWordRegExp
          .firstMatch(contentsLanguageRaw)
          ?.group(0)
          ?.toLowerCase();

    try {
      final cardMatches = cardRegExp.allMatches(dictFile);
      final cardsList = cardMatches
          .where((match) => match.group(1) != null && match.group(2) != null)
          .map((match) {
        final headword = match.group(1)!.trim();
        final text = match
            .group(2)!
            .trim()
            .replaceAll('[', '<')
            .replaceAll(']', '>')
            .replaceAll(r'\<', '[')
            .replaceAll(r'\>', ']');
        return CardDM(headword: headword, text: text);
      }).toList();
      if (name == null ||
          indexLanguage == null ||
          contentsLanguage == null ||
          cardsList.isEmpty) throw DictionaryParsingException();
      return DictionaryDM(
          name: name,
          indexLanguage: indexLanguage.toLowerCase(),
          contentLanguage: contentsLanguage.toLowerCase(),
          cards: cardsList);
    } catch (e) {
      throw DictionaryParsingException();
    }
  }
}

void printLongString(String? text) {
  if (text == null) {
    print(null);
    return;
  }
  ;
  final pattern = RegExp('.{1,800}', dotAll: true);
  pattern.allMatches(text).forEach((match) {
    print(match.group(0));
  });
}

final dummyCard = CardDM(
    headword: '-ability',
    text:
        '\r[m1][i][c][trn]suffix[/c][/i] forming nouns of quality corresponding '
        'to adjectives ending in [i]-able[/i] (such as [i]suitability[/i] '
        'corresponding to [i]suitable[/i])[/trn][/m]\r[m1][*][b]Origin:[/b]'
        '[/*][/m]\r[m2][*][com][lang id=1033]from French [i]-abilité[/i] or '
        'Latin [i]-abilitas[/lang][/com][/i][/*][/m]');
