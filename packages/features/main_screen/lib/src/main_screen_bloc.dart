import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:path/path.dart';
import 'package:user_repository/user_repository.dart';
import 'package:domain_models/domain_models.dart';

import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc(
      {required this.userRepository, required this.dictionaryProvider})
      : super(MainScreenStateInitial()) {
    _registerEventsHandler();
    // print('init MSBloc');
  }

  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;

  // final _progressStreamController = StreamController<String>();
  // late final _progressSink = _progressStreamController.sink;
  // late final progressStream = _progressStreamController.stream;

  @override
  Future<void> close() {
    // _progressStreamController.close();
    return super.close();
  }

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
      } else if (event is MainScreenEventSwapLanguages) {
        await _handleSwapLanguages(emitter);
      } else if (event is MainScreenEventDictionaryStatusChanged) {
        await _handleDictionaryStatusChanged(event, emitter);
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

  Future<void> _handleLoadingInitial(Emitter emitter, {String? message}) async {
    print('Loading initial');
    String? fromLanguage = await userRepository.getFromLanguage;
    String? toLanguage = await userRepository.getToLanguage;
    final dictionaries = await dictionaryProvider.listOfAllDictionaries;
    // print(fromLanguage);
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
    final historyCards =
        await _getHistory(fromLanguage: fromLanguage, toLanguage: toLanguage);
    emit(
      MainScreenState(
        toLanguage: toLanguage ?? '',
        fromLanguage: fromLanguage ?? '',
        dictionaryList: dictionaries,
        searchTerm: '',
        itemsList: historyCards,
        isLoading: false,
        message: message ?? '',
      ),
    );
  }

  Future<void> _handleAddDictionary(
      MainScreenEventAddDictionary event, Emitter emitter) async {
    if (extension(event.filePath) != '.dsl') {
      emitter(state.copyWith(isLoading: false, message: 'Wrong filetype'));
      return;
    }
    emitter(state.copyWith(isLoading: true, message: ''));
    await Future.delayed(const Duration(seconds: 1));
    try {
      final dictionary =
          await dictionaryProvider.createDictionary(event.filePath);
      await _handleLoadingInitial(emitter,
          message: 'Created dictionary ${dictionary.name}');
    } catch (e) {
      print(e);
      emitter(
        state.copyWith(
            isLoading: false, message: 'Smth is wrong with dictionary file'),
      );
    }
  }

  Future<void> _handleDeleteDictionary(
      MainScreenEventDeleteDictionary event, Emitter emitter) async {
    emitter(state.copyWith(isLoading: true, message: ''));
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
          isLoading: false, message: 'Could not delete dictionary'));
    }
  }

  Future<void> _handleSearchTermChanged(
      MainScreenEventSearchTermChanged event, Emitter emitter) async {
    if (event.searchTerm.isEmpty) {
      emitter(state.copyWith(
          itemsList: await _getHistory(), searchTerm: '', message: ''));
      return;
    }
    if (state.toLanguage.isEmpty || state.fromLanguage.isEmpty) {
      emitter(state.copyWith(message: 'Please choose language first'));
      return;
    }
    final term = event.searchTerm.toLowerCase().trim();
    if (term.replaceAll(RegExp(r'\s'), '').isEmpty) return;
    // get list of translations
    emitter(state.copyWith(
        isLoading: true, searchTerm: event.searchTerm, message: ''));
    String from = state.fromLanguage;
    String to = state.toLanguage;
    List<DictionaryDM> resultsDicts =
        await dictionaryProvider.getAllDictionariesWordTranslation(
            word: term,
            translateFrom: state.fromLanguage,
            translateTo: state.toLanguage,
            startsWith: true);
    if (resultsDicts.isEmpty && term.length == 1) {
      // TODO check if dictionary exists
      final alternativeResults =
          await dictionaryProvider.getAllDictionariesWordTranslation(
              word: term,
              translateFrom: state.toLanguage,
              translateTo: state.fromLanguage,
              startsWith: true);
      if (alternativeResults.isNotEmpty) {
        resultsDicts = alternativeResults;
        from = state.toLanguage;
        to = state.fromLanguage;
        userRepository.saveFromLanguage(to);
        userRepository.saveToLanguage(from);
      }
    }
    emitter(state.copyWith(
        itemsList: _getListOfFilteredSortedCardsFromDicts(resultsDicts),
        fromLanguage: from,
        toLanguage: to,
        // searchTerm: event.searchTerm.toLowerCase(),
        isLoading: false,
        message: ''));
  }

  Future<void> _handleLanguageFromChange(
      MainScreenEventLanguageFromChanged event, Emitter emitter) async {
    if (state.fromLanguage == event.languageFrom) return;
    // emitter(state.copyWith(itemsList: [], searchTerm: ''));
    final activeToLanguages = listOfAllActiveToLanguages(
        fromLanguage: event.languageFrom, forceAllDicts: true);
    String toLanguage = activeToLanguages.contains(state.toLanguage)
        ? state.toLanguage
        : activeToLanguages.first;
    userRepository.saveFromLanguage(event.languageFrom);
    userRepository.saveToLanguage(toLanguage);
    final results = state.searchTerm.isNotEmpty
        ? await dictionaryProvider.getAllDictionariesWordTranslation(
            word: state.searchTerm.toLowerCase(),
            translateFrom: event.languageFrom,
            translateTo: toLanguage)
        : <DictionaryDM>[];
    final itemsList = results.isEmpty
        ? await _getHistory(
            fromLanguage: event.languageFrom, toLanguage: toLanguage)
        : _getListOfFilteredSortedCardsFromDicts(results);
    emitter(
      state.copyWith(
          isLoading: false,
          itemsList: itemsList,
          fromLanguage: event.languageFrom,
          toLanguage: toLanguage,
          message: ''),
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
        : <DictionaryDM>[];
    final itemsList = results.isEmpty
        ? await _getHistory(
            fromLanguage: state.fromLanguage, toLanguage: event.languageTo)
        : _getListOfFilteredSortedCardsFromDicts(results);
    emitter(state.copyWith(
        isLoading: false,
        toLanguage: event.languageTo,
        itemsList: itemsList,
        message: ''));
  }

  Future<void> _handleSwapLanguages(Emitter emitter) async {
    if (state.toLanguage == state.fromLanguage) return;
    emitter(state.copyWith(isLoading: true, message: ''));
    final results = state.searchTerm.isNotEmpty
        ? await dictionaryProvider.getAllDictionariesWordTranslation(
            word: state.searchTerm.toLowerCase(),
            translateFrom: state.toLanguage,
            translateTo: state.fromLanguage)
        : <DictionaryDM>[];
    final itemsList = results.isEmpty
        ? await _getHistory(
            fromLanguage: state.toLanguage, toLanguage: state.fromLanguage)
        : _getListOfFilteredSortedCardsFromDicts(results);
    userRepository.saveToLanguage(state.fromLanguage);
    userRepository.saveFromLanguage(state.toLanguage);
    emitter(state.copyWith(
        isLoading: false,
        message: '',
        searchTerm: results.isEmpty ? '' : state.searchTerm,
        itemsList: itemsList,
        fromLanguage: state.toLanguage,
        toLanguage: state.fromLanguage));
  }

  Future<void> _handleDictionaryStatusChanged(
      MainScreenEventDictionaryStatusChanged event, Emitter emitter) async {
    try {
      await dictionaryProvider.updateDictionaryStatusChanged(
          dictionary: event.changedDictionary, status: event.status);
      String from = state.fromLanguage;
      String to = state.toLanguage;
      final dictionaries = await dictionaryProvider.listOfAllDictionaries;
      emit(state.copyWith(dictionaryList: dictionaries, message: ''));
      if (!listOfAllActiveFromLanguages().contains(from)) {
        from = listOfAllActiveFromLanguages().first;
        userRepository.saveFromLanguage(from);
      }
      if (!listOfAllActiveToLanguages(fromLanguage: from).contains(to)) {
        to = listOfAllActiveToLanguages(fromLanguage: from).first;
        userRepository.saveToLanguage(to);
      }
      emitter(state.copyWith(
          fromLanguage: from,
          toLanguage: to,
          message: '',
          dictionaryList: dictionaries));
    } catch (e) {
      emitter(state.copyWith(message: e.toString()));
    }
  }

  List<CardDM> _getListOfFilteredSortedCardsFromDicts(
      List<DictionaryDM> resultsDicts) {
    final resultsCards = <CardDM>[];
    for (DictionaryDM dict in resultsDicts) {
      resultsCards.addAll(dict.cards);
    }
    final Map<String, CardDM> filteredResults = {};
    for (CardDM result in resultsCards) {
      filteredResults.putIfAbsent(result.headword, () => result);
    }
    return filteredResults.values.toList()
      ..sort((a, b) =>
          a.headword.toLowerCase().compareTo(b.headword.toLowerCase()));
  }

  List<String> listOfAllActiveFromLanguages({bool forceAllDicts = true}) {
    List<DictionaryDM> list = forceAllDicts
        ? state.dictionaryList.toList()
        : state.dictionaryList.where((d) => d.active).toList();
    return list.map((d) => d.indexLanguage.toLowerCase()).toSet().toList();
  }

  List<String> listOfAllActiveToLanguages(
      {String? fromLanguage, bool forceAllDicts = true}) {
    List<DictionaryDM> list = forceAllDicts
        ? state.dictionaryList.toList()
        : state.dictionaryList.where((d) => d.active).toList();
    if (state.fromLanguage.isEmpty && fromLanguage == null) return [];
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

  Future<List<CardDM>> _getHistory(
      {String? fromLanguage, String? toLanguage}) async {
    // if (state.fromLanguage.isEmpty && state.toLanguage.isEmpty) {
    return (await dictionaryProvider.getHistoryCards(
            fromLanguage: fromLanguage ?? state.fromLanguage,
            toLanguage: toLanguage ?? state.toLanguage))
        .reversed
        .toList();
    // } else {
    //   return [];
    // }
  }
}
