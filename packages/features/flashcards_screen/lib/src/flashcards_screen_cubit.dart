import 'dart:math';

import 'package:equatable/equatable.dart';

import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain_models/domain_models.dart';

part 'flashcards_screen_state.dart';

class FlashCardsScreenCubit extends Cubit<FlashCardsScreenState> {
  final WizzTrainingModule wizzTrainingModule;
  final WizzDeckDM deck;
  int numberOfSuccesses = 0;

  FlashCardsScreenCubit({required this.wizzTrainingModule, required this.deck})
      : super(FlashCardsScreenStateInitial(deck: deck.copyWith(cards: [])));

  void createListOfCards() {
    if (deck.cards.length < 15) {
      emit(state.copyWith(listOfCards: deck.cards..shuffle()));
    } else {
      final cards = <WizzCardDM>[];
      for (var card in deck.cards) {
        final random = Random().nextDouble();
        final cardLevel = card.level == 0 ? 1 : card.level;
        if (random < 1 / cardLevel) cards.add(card);
      }
      emit(state.copyWith(listOfCards: cards..shuffle()));
    }
  }

  void updateCard(WizzCardDM card, bool isGood) {
    final newLevel = (isGood ? card.level + 1 : card.level - 1).clamp(1, 5);
    if (isGood) numberOfSuccesses += 1;
    if (card.level == newLevel) return;
    final index = state.listOfCards.indexWhere((element) => element == card);
    final updatedCard = card.copyWith(level: newLevel);
    emit(state.copyWith(
        listOfCards: List.from(state.listOfCards)
          ..removeAt(index)
          ..insert(index, updatedCard)));
  }

  void completeTraining() {
    wizzTrainingModule.saveTrainingProgress(
        cards: state.listOfCards, deck: deck);
    // numberOfSuccesses = 0;
  }
}
