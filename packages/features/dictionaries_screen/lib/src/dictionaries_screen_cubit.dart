import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:user_repository/user_repository.dart';

part 'dictionaries_screen state.dart';

const defaultLang = 'all';

class DictionaryScreenCubit extends Cubit<DictionariesScreenState> {
  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;

  DictionaryScreenCubit(
      {required this.userRepository, required this.dictionaryProvider})
      : super(DictionariesScreenStateInitial());

  Future<void> initialLoad({String? message}) async {
    final fromLanguage = state.fromLanguage ??
        (await userRepository.getFromLanguage) ??
        defaultLang;
    final toLanguage =
        state.toLanguage ?? (await userRepository.getToLanguage) ?? defaultLang;
    final allDictionaries = await dictionaryProvider.listOfAllDictionaries;
    final filteredDictionaries = _filterDictionaries(
        allDictionaries: allDictionaries,
        fromLanguage: fromLanguage,
        toLanguage: toLanguage);
    final fromLanguages =
        _listOfAllActiveFromLanguages(dictionaries: allDictionaries);
    final toLanguages = _listOfAllActiveToLanguages(
        dictionaries: allDictionaries, fromLanguage: fromLanguage);
    bool isSwappable = fromLanguage != toLanguage &&
        allDictionaries
            .where((d) =>
                d.contentLanguage == fromLanguage &&
                d.indexLanguage == toLanguage)
            .isNotEmpty;
    emit(state.copyWith(
        fromLanguage: fromLanguage,
        toLanguage: toLanguage,
        fromLanguages: [defaultLang, ...fromLanguages],
        toLanguages: [defaultLang, ...toLanguages],
        dictionaryList: filteredDictionaries,
        isSwappable: isSwappable,
        isLoading: false,
        message: message));
  }

  void dictionaryStatusChanged(
      DictionaryDM changedDictionary, bool status) async {
    try {
      await dictionaryProvider.updateDictionaryStatusChanged(
          dictionary: changedDictionary, status: status);
      // String from = state.fromLanguage ?? defaultLang;
      // String to = state.toLanguage ?? defaultLang;
      // final allDictionaries = await dictionaryProvider.listOfAllDictionaries;
      // final filteredDictionaries = _filterDictionaries(
      //     allDictionaries: allDictionaries, fromLanguage: from, toLanguage: to);
      emit(state.copyWith(
          message: null,
          dictionaryList: state.dictionaryList.map((d) {
            if (d == changedDictionary) return d.copyWith(active: status);
            return d;
          }).toList()));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  void addDictionary(String filePath) async {
    if (extension(filePath) != '.dsl') {
      emit(state.copyWith(isLoading: false, message: 'Wrong filetype'));
      return;
    }
    emit(state.copyWith(isLoading: true, message: 'Creating dictionary...'));
    await Future.delayed(const Duration(seconds: 1));
    try {
      final dictionary = await dictionaryProvider.createDictionary(filePath);
      await initialLoad(message: 'Created dictionary ${dictionary.name}');
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            isLoading: false,
            message: 'Something went wrong is wrong with dictionary file'),
      );
    }
  }

  Future<void> deleteDictionary(DictionaryDM dictionary) async {
    emit(state.copyWith(isLoading: true));
    try {
      await dictionaryProvider.deleteDictionary(dictionary);
      // final from = await userRepository.getFromLanguage;
      // final to = await userRepository.getToLanguage;
      String? from = state.fromLanguage;
      String? to = state.toLanguage;
      //TODO check picked languages!
      final allDictionaries = await dictionaryProvider.listOfAllDictionaries;
      final listFrom = _listOfAllActiveFromLanguages(
          forceAllDicts: true, dictionaries: allDictionaries);
      final listTo = _listOfAllActiveToLanguages(
          forceAllDicts: true, dictionaries: allDictionaries);
      if (!listFrom.contains(from))
        from = listFrom.isEmpty ? null : listFrom.first;
      if (!listTo.contains(to)) to = listTo.isEmpty ? null : listTo.first;
      await initialLoad(message: 'Successfully deleted ${dictionary.name}');
    } catch (e) {
      // print('Could not delete dictionary');
      emit(state.copyWith(
          isLoading: false, message: 'Could not delete dictionary'));
    }
  }

  Future<void> languageFromChanged(String fromLanguage) async {
    if (state.fromLanguage == fromLanguage) return;
    final allDictionaries = (await dictionaryProvider.listOfAllDictionaries);
    final toLanguages = _listOfAllActiveToLanguages(
        fromLanguage: fromLanguage,
        forceAllDicts: true,
        dictionaries: allDictionaries);
    print(toLanguages);
    String toLanguage =
        toLanguages.contains(state.toLanguage) && state.toLanguage != null
            ? state.toLanguage!
            : toLanguages.first;
    final filteredList = _filterDictionaries(
        allDictionaries: allDictionaries,
        fromLanguage: fromLanguage,
        toLanguage: toLanguage);
    bool isSwappable = fromLanguage != toLanguage &&
        allDictionaries
            .where((d) =>
                d.contentLanguage == fromLanguage &&
                d.indexLanguage == toLanguage)
            .isNotEmpty;
    // final fromLanguages =
    // listOfAllActiveFromLanguages(dictionaries: allDictionaries);
    // final toLanguages = listOfAllActiveToLanguages(
    //     dictionaries: allDictionaries, fromLanguage: fromLanguage);
    emit(
      state.copyWith(
          dictionaryList: filteredList,
          fromLanguage: fromLanguage,
          toLanguages: [defaultLang, ...toLanguages],
          toLanguage: toLanguage,
          isSwappable: isSwappable),
    );
  }

  Future<void> languageToChanged(String toLanguage) async {
    if (state.toLanguage == toLanguage) return;
    final allDictionaries = (await dictionaryProvider.listOfAllDictionaries);
    final filteredList = _filterDictionaries(
        allDictionaries: allDictionaries,
        fromLanguage: state.fromLanguage ?? defaultLang,
        toLanguage: toLanguage);
    bool isSwappable = (state.fromLanguage ?? defaultLang) != toLanguage &&
        allDictionaries
            .where((d) =>
                d.contentLanguage == (state.fromLanguage ?? defaultLang) &&
                d.indexLanguage == toLanguage)
            .isNotEmpty;
    emit(state.copyWith(
      isLoading: false,
      toLanguage: toLanguage,
      fromLanguage: state.fromLanguage ?? defaultLang,
      dictionaryList: filteredList,
      isSwappable: isSwappable,
    ));
  }

  void swapLanguages() async {
    if (state.toLanguage == state.fromLanguage) return;
    final allDictionaries = await dictionaryProvider.listOfAllDictionaries;
    bool isSwappable = state.fromLanguage != state.toLanguage &&
        allDictionaries
            .where((d) =>
                d.contentLanguage == state.fromLanguage &&
                d.indexLanguage == state.toLanguage)
            .isNotEmpty;
    if (isSwappable) {
      final filteredList = _filterDictionaries(
          allDictionaries: allDictionaries,
          fromLanguage: state.toLanguage!,
          toLanguage: state.fromLanguage!);
      final fromLanguages =
          _listOfAllActiveFromLanguages(dictionaries: allDictionaries);
      final toLanguages = _listOfAllActiveToLanguages(
          fromLanguage: state.toLanguage,
          forceAllDicts: true,
          dictionaries: allDictionaries);

      emit(state.copyWith(
          dictionaryList: filteredList,
          fromLanguage: state.toLanguage,
          toLanguage: state.fromLanguage,
          fromLanguages: [defaultLang, ...fromLanguages],
          toLanguages: [defaultLang, ...toLanguages]));
    }
  }

  List<String> _listOfAllActiveFromLanguages(
      {bool forceAllDicts = true, List<DictionaryDM>? dictionaries}) {
    List<DictionaryDM> list = forceAllDicts
        ? dictionaries ?? state.dictionaryList.toList()
        : dictionaries ?? state.dictionaryList.where((d) => d.active).toList();
    return list.map((d) => d.indexLanguage.toLowerCase()).toSet().toList();
  }

  List<String> _listOfAllActiveToLanguages(
      {String? fromLanguage,
      bool forceAllDicts = true,
      List<DictionaryDM>? dictionaries}) {
    List<DictionaryDM> list = forceAllDicts
        ? dictionaries ?? state.dictionaryList.toList()
        : dictionaries ?? state.dictionaryList.where((d) => d.active).toList();
    // if (state.fromLanguage == null ||
    //     state.fromLanguage!.isEmpty && fromLanguage == null) return [];
    List<String> res;
    if ((fromLanguage ?? state.fromLanguage) == defaultLang) {
      res = list
          // .where((d) => d.contentLanguage == state.toLanguage)
          .map((d) => d.contentLanguage.toLowerCase())
          .toSet()
          .toList();
    } else {
      res = list
          .where((d) =>
              d.indexLanguage.toLowerCase() ==
              (fromLanguage ?? state.fromLanguage!).toLowerCase())
          .map((d) => d.contentLanguage.toLowerCase())
          .toSet()
          .toList();
    }
    return res;
  }

  List<DictionaryDM> _filterDictionaries(
      {required List<DictionaryDM> allDictionaries,
      required String fromLanguage,
      required String toLanguage}) {
    final List<DictionaryDM> filteredList = [];
    if (fromLanguage == defaultLang && toLanguage == defaultLang) {
      filteredList.addAll(allDictionaries);
    } else if (fromLanguage != defaultLang && toLanguage == defaultLang) {
      filteredList.addAll(
          allDictionaries.where((d) => d.indexLanguage == fromLanguage));
    } else if (fromLanguage == defaultLang && toLanguage != defaultLang) {
      filteredList.addAll(
          allDictionaries.where((d) => d.contentLanguage == toLanguage));
    } else {
      filteredList.addAll(allDictionaries.where((d) =>
          d.contentLanguage == toLanguage && d.indexLanguage == fromLanguage));
    }
    return filteredList;
  }
}
