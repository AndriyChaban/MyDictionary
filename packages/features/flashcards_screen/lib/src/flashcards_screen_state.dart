part of 'flashcards_screen_cubit.dart';

class FlashCardsScreenState extends Equatable {
  final bool isLoading;
  final String? message;
  final List<WizzCardDM> listOfCards;
  final WizzDeckDM deck;
  final int currentProgress;

  const FlashCardsScreenState({
    required this.isLoading,
    this.message,
    required this.listOfCards,
    required this.deck,
    required this.currentProgress,
  });

  @override
  List<Object?> get props => [
        isLoading,
        message,
        listOfCards,
        deck,
        currentProgress,
      ];

  FlashCardsScreenState copyWith({
    bool? isLoading,
    String? message,
    List<WizzCardDM>? listOfCards,
    WizzDeckDM? deck,
    int? currentProgress,
  }) {
    return FlashCardsScreenState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      listOfCards: listOfCards ?? this.listOfCards,
      deck: deck ?? this.deck,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }
}

class FlashCardsScreenStateInitial extends FlashCardsScreenState {
  const FlashCardsScreenStateInitial({required WizzDeckDM deck})
      : super(
            currentProgress: 0,
            deck: deck,
            isLoading: false,
            listOfCards: const []);
}
