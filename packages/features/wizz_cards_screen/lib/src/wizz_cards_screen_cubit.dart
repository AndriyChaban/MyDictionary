import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wizz_training_module/wizz_training_module.dart';

part 'wizz_cards_screen_state.dart';

class WizzCardsScreenCubit extends Cubit<WizzCardsScreenState> {
  final WizzTrainingModule wizzTrainingModule;
  final WizzDeckDM deck;
  WizzCardsScreenCubit({required this.deck, required this.wizzTrainingModule})
      : super(WizzCardsScreenInitial(deck));

  void refreshListOfCards() async {
    final listOfCards = await wizzTrainingModule.getListOfCards(state.deck);
    emit(state.copyWith(listOfCards: listOfCards ?? <WizzCardDM>[]));
  }

  void createNewCard(WizzCardDM card) async {
    wizzTrainingModule.createNewCard(card: card, deck: state.deck);
    refreshListOfCards();
  }

  void deleteCard(WizzCardDM card) async {
    final result = await wizzTrainingModule.deleteCard(card: card, deck: deck);
    if (result == false) {
      emit(state.copyWith(errorMessage: 'No such card'));
    } else {
      emit(state.copyWith(errorMessage: 'Successfully deleted card'));
      refreshListOfCards();
    }
  }

  void editCard(WizzCardDM oldCard, WizzCardDM newCard) async {
    final result = await wizzTrainingModule.editCard(
        oldCard: oldCard, newCard: newCard, deck: deck);
    if (result == false) {
      emit(state.copyWith(errorMessage: 'Something is wrong with card'));
    } else {
      refreshListOfCards();
    }
  }

  Future<String?> validateWord(String? word) async {
    String? validation;
    if (word == null || word.isEmpty) return 'Please enter name';
    final list = state.listOfCards;
    validation = list.where((d) => d.word == word).isEmpty
        ? null
        : 'This word already exists';
    return validation;
  }
}
