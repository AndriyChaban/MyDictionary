part of 'dictionaries_screen_cubit.dart';

class DictionariesScreenState extends Equatable {
  final List<DictionaryDM> dictionaryList;
  final String? fromLanguage;
  final String? toLanguage;
  final List<String> fromLanguages;
  final List<String> toLanguages;
  final String? message;
  final bool isLoading;
  final bool isSwappable;

  const DictionariesScreenState({
    required this.dictionaryList,
    required this.fromLanguage,
    required this.toLanguage,
    required this.message,
    required this.isLoading,
    required this.fromLanguages,
    required this.toLanguages,
    required this.isSwappable,
  });

  @override
  List<Object?> get props => [
        dictionaryList,
        fromLanguage,
        toLanguage,
        message,
        isLoading,
        fromLanguages,
        toLanguages,
        isSwappable
      ];

  DictionariesScreenState copyWith({
    List<DictionaryDM>? dictionaryList,
    String? fromLanguage,
    String? toLanguage,
    List<String>? fromLanguages,
    List<String>? toLanguages,
    String? message,
    bool? isLoading,
    bool? isSwappable,
  }) {
    return DictionariesScreenState(
      dictionaryList: dictionaryList ?? this.dictionaryList,
      fromLanguage: fromLanguage ?? this.fromLanguage,
      toLanguage: toLanguage ?? this.toLanguage,
      fromLanguages: fromLanguages ?? this.fromLanguages,
      toLanguages: toLanguages ?? this.toLanguages,
      message: message,
      isLoading: isLoading ?? this.isLoading,
      isSwappable: isSwappable ?? this.isSwappable,
    );
  }
}

class DictionariesScreenStateInitial extends DictionariesScreenState {
  DictionariesScreenStateInitial()
      : super(
            dictionaryList: [],
            fromLanguages: [],
            toLanguages: [],
            fromLanguage: null,
            toLanguage: null,
            message: null,
            isLoading: false,
            isSwappable: false);
}
