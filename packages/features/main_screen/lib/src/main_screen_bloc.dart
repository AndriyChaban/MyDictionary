import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:domain_models/domain_models.dart';
import 'package:main_screen/src/main_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc(
      {required this.userRepository, required this.dictionaryProvider})
      : super(MainScreenStateInitial()) {
    _registerEventsHandler();
  }

  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;

  void _registerEventsHandler() {
    on<MainScreenEvent>((event, emitter) async {
      if (event is MainScreenEventLoadInitial) {
        await _handleLoadingInitial(emitter);
      } else if (event is MainScreenEventAddDictionary) {
        await _handleAddDictionary(event, emitter);
      } else if (event is MainScreenEventDeleteDictionary) {
        await _handleDeleteDictionary(event, emitter);
      } else if (event is MainScreenEventSearchTermChanged) {
        await _handleSearchTermChanged(event, emitter);
      } else if (event is MainScreenEventLanguageFromChanged) {
        await _handleLanguageFromChange(event, emitter);
      } else if (event is MainScreenEventLanguageToChanged) {
        await _handleLanguageToChange(event, emitter);
      } else if (event is MainScreenEventFakeLoading) {
        await _handleFakeLoading(emitter);
      }
    });
  }

  Future<void> _handleFakeLoading(Emitter emitter) async {
    print('start');
    emitter(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 3));
    emitter(state.copyWith(isLoading: false));
    print('finish');
  }

  Future<void> _handleLoadingInitial(Emitter emitter) async {
    String? fromLanguage = await userRepository.getFromLanguage;
    String? toLanguage = await userRepository.getToLanguage;
    final dictionaries = await dictionaryProvider.listOfAllDictionaries;
    if ((fromLanguage != null && fromLanguage.isNotEmpty) &&
        (toLanguage == null || toLanguage.isEmpty)) {
      toLanguage = dictionaries
          .where((d) =>
              d.indexLanguage.toLowerCase() == fromLanguage!.toLowerCase())
          .first
          .contentLanguage;
    }
    //check languages: from and to
    bool flag = false;
    if ((fromLanguage != null && fromLanguage.isNotEmpty) &&
        (toLanguage != null && toLanguage.isNotEmpty)) {
      for (var d in dictionaries) {
        if (d.indexLanguage == fromLanguage &&
            d.contentLanguage == toLanguage) {
          flag = true;
        }
      }
    }
    if (!flag) {
      fromLanguage = '';
      toLanguage = '';
    }
    emitter(
      state.copyWith(
        toLanguage: toLanguage ?? '',
        fromLanguage: fromLanguage ?? '',
        dictionaryList: dictionaries,
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> _handleAddDictionary(
      MainScreenEventAddDictionary event, Emitter emitter) async {
    print('start');
    emitter(state.copyWith(isLoading: true, error: null));
    await Future.delayed(const Duration(seconds: 1));
    try {
      // await compute(dictionaryProvider.createDictionary, event.filePath);
      await dictionaryProvider.createDictionary(event.filePath);
      await _handleLoadingInitial(emitter);
    } catch (e) {
      print(e);
      emitter(
        state.copyWith(
            isLoading: false, error: 'Smth is wrong with dictionary file'),
      );
      print('finish');
    }
  }

  Future<void> _handleDeleteDictionary(
      MainScreenEventDeleteDictionary event, Emitter emitter) async {
    emitter(state.copyWith(isLoading: true, error: null));
    try {
      dictionaryProvider.deleteDictionary(event.dictionary);
      // final from = await userRepository.getFromLanguage;
      // final to = await userRepository.getToLanguage;
      final from = state.fromLanguage;
      final to = state.toLanguage;
      //TODO check picked languages!
      if (from == event.dictionary.indexLanguage &&
          to == event.dictionary.contentLanguage) {
        userRepository.saveFromLanguage(null);
        userRepository.saveToLanguage(null);
      }
      await _handleLoadingInitial(emitter);
    } catch (e) {
      print('Could not delete dictionary');
      emitter(state.copyWith(
          isLoading: false, error: 'Could not delete dictionary'));
    }
  }

  Future<void> _handleSearchTermChanged(
      MainScreenEventSearchTermChanged event, Emitter emitter) async {
    // List<CardDM> history = [];
    if (event.searchTerm.isEmpty) {
      // TODO history!!!
      // TODO make a set of extracts, sorted by alphabet
      emitter(state.copyWith(itemsList: [], searchTerm: '', error: null));
      return;
    }
    if (state.toLanguage.isEmpty || state.fromLanguage.isEmpty) {
      emitter(state.copyWith(error: 'Please choose language first'));
      return;
    }
    final term = event.searchTerm.toLowerCase().trim();
    if (term.replaceAll(RegExp(r'\s'), '').isEmpty) return;
    // get list of translations
    emitter(state.copyWith(isLoading: true));
    final results = await dictionaryProvider.getAllDictionariesWordTranslation(
        word: term,
        translateFrom: state.fromLanguage,
        translateTo: state.toLanguage,
        startsWith: true);
    // print('results: $results');
    final Map<String, CardDM> filteredResults = {};
    for (CardDM result in results) {
      filteredResults.putIfAbsent(result.headword, () => result);
    }
    emitter(state.copyWith(
        itemsList: filteredResults.values.toList()
          ..sort((a, b) =>
              a.headword.toLowerCase().compareTo(b.headword.toLowerCase())),
        searchTerm: event.searchTerm.toLowerCase(),
        isLoading: false,
        error: null));
  }

  Future<void> _handleLanguageFromChange(
      MainScreenEventLanguageFromChanged event, Emitter emitter) async {
    if (state.fromLanguage == event.languageFrom) return;
    emitter(state.copyWith(itemsList: [], searchTerm: ''));
    final activeToLanguages =
        listOfAllActiveToLanguages(fromLanguage: event.languageFrom);
    userRepository.saveFromLanguage(event.languageFrom);
    userRepository.saveToLanguage(activeToLanguages.first);
    final results = state.searchTerm.isNotEmpty
        ? await dictionaryProvider.getAllDictionariesWordTranslation(
            word: state.searchTerm.toLowerCase(),
            translateFrom: state.fromLanguage,
            translateTo: state.toLanguage)
        : <CardDM>[];
    emitter(
      state.copyWith(
        isLoading: false,
        itemsList: results,
        fromLanguage: event.languageFrom,
        toLanguage: activeToLanguages.first,
      ),
    );
  }

  Future<void> _handleLanguageToChange(
      MainScreenEventLanguageToChanged event, Emitter emitter) async {
    if (state.toLanguage == event.languageTo) return;
    userRepository.saveToLanguage(event.languageTo);
    final results = state.searchTerm.isNotEmpty
        ? await dictionaryProvider.getAllDictionariesWordTranslation(
            word: state.searchTerm.toLowerCase(),
            translateFrom: state.fromLanguage,
            translateTo: event.languageTo)
        : <CardDM>[];
    emitter(state.copyWith(
      isLoading: false,
      toLanguage: event.languageTo,
      itemsList: results,
    ));
  }

  List<String> get listOfAllActiveFromLanguages {
    List<DictionaryDM> list = state.dictionaryList;
    // print(list.first.indexLanguage);
    return list.map((d) => d.indexLanguage.toLowerCase()).toSet().toList();
  }

  List<String> listOfAllActiveToLanguages({String? fromLanguage}) {
    List<DictionaryDM> list = state.dictionaryList;
    if (state.fromLanguage.isEmpty && fromLanguage == null) return [];
    // print(list.first.indexLanguage);
    final res = list
        .where((d) =>
            d.indexLanguage.toLowerCase() ==
            (fromLanguage ?? state.fromLanguage).toLowerCase())
        .map((d) => d.contentLanguage.toLowerCase())
        .toSet()
        .toList();
    return res;
  }

  List<DictionaryDM> get listOfAllMatchingDictionaries {
    final list = state.dictionaryList;
    return list.where((d) {
      final res = d.contentLanguage == state.toLanguage &&
          d.indexLanguage == state.fromLanguage;
      return res;
    }).toList();
  }

  Future<List<CardDM>> listOfWordTranslations(String word,
      {String? from, String? to}) async {
    final results = await dictionaryProvider.getAllDictionariesWordTranslation(
        word: word,
        translateFrom: from ?? state.fromLanguage,
        translateTo: to ?? state.toLanguage,
        startsWith: false);
    return results;
  }
}
