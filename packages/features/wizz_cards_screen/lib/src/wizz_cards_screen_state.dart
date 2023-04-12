part of 'wizz_cards_screen_cubit.dart';

class WizzCardsScreenState extends Equatable {
  final List<WizzCardDM> listOfCards;
  final WizzDeckDM deck;
  final String? errorMessage;

  const WizzCardsScreenState(
      {required this.deck, this.listOfCards = const [], this.errorMessage});

  @override
  List<Object?> get props => [listOfCards, deck, errorMessage];

  WizzCardsScreenState copyWith({
    List<WizzCardDM>? listOfCards,
    WizzDeckDM? deck,
    String? errorMessage,
  }) {
    return WizzCardsScreenState(
      listOfCards: listOfCards ?? this.listOfCards,
      deck: deck ?? this.deck,
      errorMessage: errorMessage,
    );
  }
}

class WizzCardsScreenInitial extends WizzCardsScreenState {
  const WizzCardsScreenInitial(deck) : super(deck: deck);
}
