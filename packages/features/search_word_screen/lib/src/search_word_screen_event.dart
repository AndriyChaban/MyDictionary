part of 'search_word_screen_bloc.dart';

abstract class SearchWordScreenEvent extends Equatable {
  const SearchWordScreenEvent();
  @override
  List<Object?> get props => [];
}

class SearchWordScreenEventInitial extends SearchWordScreenEvent {
  const SearchWordScreenEventInitial();
}

class SearchWordScreenEventFakeLoading extends SearchWordScreenEvent {
  const SearchWordScreenEventFakeLoading();
}

class SearchWordScreenEventClearHistory extends SearchWordScreenEvent {
  const SearchWordScreenEventClearHistory();
}

// class MainScreenEventDeleteDictionary extends SearchWordScreenEvent {
//   const MainScreenEventDeleteDictionary(this.dictionary);
//   final DictionaryDM dictionary;
// }

class SearchWordScreenEventSearchTermChanged extends SearchWordScreenEvent {
  const SearchWordScreenEventSearchTermChanged(this.searchTerm);
  final String searchTerm;
  @override
  List<Object?> get props => [searchTerm];
}

class SearchWordScreenEventLanguageFromChanged extends SearchWordScreenEvent {
  const SearchWordScreenEventLanguageFromChanged(this.languageFrom);
  final String languageFrom;
  @override
  List<Object?> get props => [languageFrom];
}

class SearchWordScreenEventLanguageToChanged extends SearchWordScreenEvent {
  const SearchWordScreenEventLanguageToChanged(this.languageTo);
  final String languageTo;
  @override
  List<Object?> get props => [languageTo];
}

class SearchWordScreenEventSwapLanguages extends SearchWordScreenEvent {
  const SearchWordScreenEventSwapLanguages();
}

// class MainScreenEventDictionaryStatusChanged extends SearchWordScreenEvent {
//   final DictionaryDM changedDictionary;
//   final bool status;
//   const MainScreenEventDictionaryStatusChanged(
//       {required this.changedDictionary, required this.status});
//   @override
//   List<Object?> get props => [changedDictionary];
// }

// class MainScreenEventDictionaryAdded extends SearchWordScreenEvent {
//   final DictionaryDM addedDictionary;
//
//   const MainScreenEventDictionaryAdded({
//     required this.addedDictionary,
//   });
//   @override
//   List<Object?> get props => [addedDictionary];
// }
