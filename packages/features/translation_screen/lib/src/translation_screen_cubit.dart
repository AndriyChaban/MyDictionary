import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:domain_models/domain_models.dart';

import 'translation_screen_state.dart';

class TranslationScreenCubit extends Cubit<TranslationScreenState> {
  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  String? fromLanguage;
  String? toLanguage;
  TranslationScreenCubit({
    required this.userRepository,
    required this.dictionaryProvider,
  }) : super(const TranslationScreenStateInitial());

  Future<List<DictionaryDM>> _listOfWordTranslations(String word,
      {String? from, String? to}) async {
    fromLanguage = fromLanguage ?? (await userRepository.getFromLanguage)!;
    toLanguage = toLanguage ?? (await userRepository.getToLanguage)!;
    var results = await dictionaryProvider.getAllDictionariesWordTranslation(
        word: word,
        translateFrom: from ?? fromLanguage!,
        translateTo: to ?? toLanguage!,
        startsWith: false);
    if (results.isEmpty) {
      results = await dictionaryProvider.getAllDictionariesWordTranslation(
          word: word,
          translateFrom: toLanguage!,
          translateTo: fromLanguage!,
          startsWith: false);
    }
    return results;
  }

  void getWordTranslations(String word, {String? from, String? to}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final listOfDictionariesWithTranslations =
          await _listOfWordTranslations(word, from: from, to: to);
      if (listOfDictionariesWithTranslations.isNotEmpty) {
        final headword =
            listOfDictionariesWithTranslations.first.cards.first.headword;
        final text = listOfDictionariesWithTranslations.first.cards.first.text;
        final dictionary = listOfDictionariesWithTranslations.first;
        _handleAddToHistory(
            card: CardDM(headword: headword, text: text),
            dictionaryName: dictionary.name,
            from: dictionary.indexLanguage,
            to: dictionary.contentLanguage);
      }
      emit(state.copyWith(
          isLoading: false,
          listOfDictionariesWithTranslations:
              listOfDictionariesWithTranslations));
    } catch (e) {
      print(e);
    }
  }

  void _handleAddToHistory(
      {required CardDM card,
      String? from,
      String? to,
      required String dictionaryName}) async {
    fromLanguage =
        from ?? fromLanguage ?? (await userRepository.getFromLanguage)!;
    toLanguage = to ?? toLanguage ?? (await userRepository.getToLanguage)!;
    dictionaryProvider.addCardToHistory(
        card: card,
        fromLanguage: fromLanguage!,
        toLanguage: toLanguage!,
        dictionaryName: dictionaryName);
  }

  void setSmallBoxParameters(
      {required String text, required RenderBox? renderBox}) async {
    var translations = await _listOfWordTranslations(text);
    // if (translations.isEmpty) {
    //   translations = await _listOfWordTranslations(text,
    //       from: toLanguage, to: fromLanguage);
    // }
    final String? translation =
        translations.isNotEmpty ? translations.first.cards.first.text : null;
    emit(state.copyWith(
        smallBoxParameters: SmallBoxParameters(
      text: text,
      translation: translation,
      renderBox: renderBox,
    )));
  }

  void removeSmallBox() {
    emit(state.copyWith(
        smallBoxParameters: const SmallBoxParameters(
          text: '',
          renderBox: null,
        ),
        currentWordIndex: -1,
        currentCardIndex: -1));
  }

  void setSelectedWordIndices(
      {required int cardIndex, required int nodeIndex}) {
    emit(state.copyWith(
        currentCardIndex: cardIndex, currentWordIndex: nodeIndex));
  }
}
