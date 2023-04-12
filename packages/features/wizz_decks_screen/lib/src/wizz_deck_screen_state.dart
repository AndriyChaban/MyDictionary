import "package:equatable/equatable.dart";
import 'package:domain_models/domain_models.dart';

class WizzDeckScreenState extends Equatable {
  final String fromLanguage;
  final String toLanguage;
  final List<WizzDeckDM>? listOfDecks;
  final WizzDeckDM? currentWizzDeck;
  final bool isLoading;
  final String? errorMessage;

  const WizzDeckScreenState({
    required this.fromLanguage,
    required this.toLanguage,
    this.currentWizzDeck,
    this.listOfDecks,
    this.isLoading = false,
    this.errorMessage
  });

  @override
  List<Object?> get props =>
      [fromLanguage, toLanguage, currentWizzDeck, listOfDecks, errorMessage];

  WizzDeckScreenState copyWith({
    String? fromLanguage,
    String? toLanguage,
    List<WizzDeckDM>? listOfDecks,
    WizzDeckDM? currentWizzDeck,
    bool? isLoading,
    String? errorMessage
  }) {
    return WizzDeckScreenState(
      fromLanguage: fromLanguage ?? this.fromLanguage,
      toLanguage: toLanguage ?? this.toLanguage,
      listOfDecks: listOfDecks ?? this.listOfDecks,
      currentWizzDeck: currentWizzDeck ?? this.currentWizzDeck,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage
    );
  }
}

class WizzDeckScreenStateInitial extends WizzDeckScreenState {
  const WizzDeckScreenStateInitial()
      : super(fromLanguage: 'all', toLanguage: 'all', listOfDecks: const []);
}
