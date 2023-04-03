import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class MainScreenState extends Equatable {
  final List<CardDM> itemsList;

  final List<DictionaryDM> dictionaryList;
  final String fromLanguage;
  final String toLanguage;
  // final List<String> activeFromLanguages;
  // final List<String> activeToLanguages;
  final String searchTerm;
  final int? nextPage;
  final bool isLoading;
  final String? error;

  const MainScreenState({
    this.itemsList = const [],
    this.dictionaryList = const [],
    this.fromLanguage = '',
    this.toLanguage = '',
    // this.activeFromLanguages = const [],
    // this.activeToLanguages = const [],
    this.searchTerm = '',
    this.isLoading = false,
    this.nextPage,
    this.error,
  });

  @override
  List<Object?> get props => [
        itemsList,
        dictionaryList,
        fromLanguage,
        toLanguage,
        // activeFromLanguages,
        // activeToLanguages,
        searchTerm,
        isLoading,
        nextPage,
        error
      ];

  MainScreenState copyWith(
      {List<CardDM>? itemsList,
      String? fromLanguage,
      String? toLanguage,
      List<DictionaryDM>? dictionaryList,
      // List<String>? activeFromLanguages,
      // List<String>? activeToLanguages,
      String? searchTerm,
      int? nextPage,
      bool? isLoading,
      String? error}) {
    return MainScreenState(
      itemsList: itemsList ?? this.itemsList,
      fromLanguage: fromLanguage ?? this.fromLanguage,
      toLanguage: toLanguage ?? this.toLanguage,
      dictionaryList: dictionaryList ?? this.dictionaryList,
      // activeFromLanguages: activeFromLanguages ?? this.activeFromLanguages,
      // activeToLanguages: activeToLanguages ?? this.activeToLanguages,
      searchTerm: searchTerm ?? this.searchTerm,
      nextPage: nextPage ?? this.nextPage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MainScreenStateInitial extends MainScreenState {
  MainScreenStateInitial() : super();
}
