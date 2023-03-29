import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();
  @override
  List<Object?> get props => [];
}

class MainScreenEventLoadInitial extends MainScreenEvent {
  const MainScreenEventLoadInitial();
}

class MainScreenEventFakeLoading extends MainScreenEvent {
  const MainScreenEventFakeLoading();
}

class MainScreenEventAddDictionary extends MainScreenEvent {
  const MainScreenEventAddDictionary(this.filePath);
  final String filePath;
}

class MainScreenEventDeleteDictionary extends MainScreenEvent {
  const MainScreenEventDeleteDictionary(this.dictionary);
  final DictionaryDM dictionary;
}

class MainScreenEventSearchTermChanged extends MainScreenEvent {
  const MainScreenEventSearchTermChanged(this.searchTerm);
  final String searchTerm;
  @override
  List<Object?> get props => [searchTerm];
}

class MainScreenEventLanguageFromChanged extends MainScreenEvent {
  const MainScreenEventLanguageFromChanged(this.languageFrom);
  final String languageFrom;
  @override
  List<Object?> get props => [languageFrom];
}

class MainScreenEventLanguageToChanged extends MainScreenEvent {
  const MainScreenEventLanguageToChanged(this.languageTo);
  final String languageTo;
  @override
  List<Object?> get props => [languageTo];
}

class MainScreenEventSwapLanguages extends MainScreenEvent {
  const MainScreenEventSwapLanguages();
}

class MainScreenEventDictionariesStatusChanged extends MainScreenEvent {
  final DictionaryDM changedDictionary;

  const MainScreenEventDictionariesStatusChanged({
    required this.changedDictionary,
  });
  @override
  List<Object?> get props => [changedDictionary];
}

class MainScreenEventDictionaryAdded extends MainScreenEvent {
  final DictionaryDM addedDictionary;

  const MainScreenEventDictionaryAdded({
    required this.addedDictionary,
  });
  @override
  List<Object?> get props => [addedDictionary];
}
