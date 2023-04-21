import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:domain_models/domain_models.dart';
import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:components/components.dart';

import './components/add_edit_card_dialog.dart';
import './wizz_cards_screen_cubit.dart';

class WizzCardsScreen extends StatefulWidget {
  const WizzCardsScreen(
      {Key? key,
      required this.deck,
      required this.wizzTrainingModule,
      required this.pop,
      this.dictionaryFromTranslationScreen,
      required this.backToSearchWordScreen,
      required this.pushToSimpleTranslationCard})
      : super(key: key);
  final WizzDeckDM deck;
  final DictionaryDM? dictionaryFromTranslationScreen;
  final WizzTrainingModule wizzTrainingModule;
  final Function(BuildContext, dynamic) pop;
  final Function(BuildContext, String) backToSearchWordScreen;
  final Function(BuildContext, WizzCardDM) pushToSimpleTranslationCard;

  static const routeName = 'wizz-cards';

  @override
  State<WizzCardsScreen> createState() => _WizzCardsScreenState();
}

class _WizzCardsScreenState extends State<WizzCardsScreen> {
  bool initial = true;

  void _onClickAddCard(BuildContext context, WizzCardsScreenCubit cubit) async {
    final response = await showDialog<WizzCardDM>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddEditWizzCardDialog(
              cardForEditing: null,
              cardFromDictionary: null,
              deck: widget.deck,
              nameValidator: (word) async {
                final response = await cubit.validateWord(word);
                return response;
              },
              popCallback: widget.pop,
            ));
    if (response != null) {
      cubit.createNewCard(response);
    }
  }

  void _onAddCardFromTranslationScreen(
      BuildContext context, WizzCardsScreenCubit cubit) async {
    final card = await showDialog<WizzCardDM>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddEditWizzCardDialog(
              cardForEditing: null,
              cardFromDictionary:
                  widget.dictionaryFromTranslationScreen!.cards.first,
              deck: widget.deck,
              nameValidator: (word) async {
                final response = await cubit.validateWord(word);
                return response;
              },
              popCallback: widget.pop,
              pushToSimpleTranslationCard: widget.pushToSimpleTranslationCard,
            ));
    if (card != null && mounted) {
      cubit.createNewCard(card);
    }
    if (mounted) {
      widget.backToSearchWordScreen(context,
          widget.dictionaryFromTranslationScreen!.cards.first.headword);
    }
  }

  void _onClickEditDeck(BuildContext context, WizzCardsScreenCubit cubit,
      WizzCardDM oldCard) async {
    final newCard = await showDialog<WizzCardDM>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddEditWizzCardDialog(
              cardForEditing: oldCard,
              cardFromDictionary: null,
              deck: widget.deck,
              nameValidator: (word) async {
                final response = await cubit.validateWord(word);
                return response;
              },
              popCallback: widget.pop,
              pushToSimpleTranslationCard: widget.pushToSimpleTranslationCard,
            ));
    if (newCard != null) {
      cubit.editCard(oldCard, newCard);
    }
  }

  void _onBackPressed(BuildContext context) {
    widget.pop(context, true);
  }

  void _onDeleteCard(BuildContext context, WizzCardDM card) async {
    final response = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConfirmCancelDialog(
            title: 'Are you sure?',
            onCancel: () => widget.pop(context, false),
            onConfirm: () => widget.pop(context, true));
      },
    );
    if (response == true && mounted) {
      context.read<WizzCardsScreenCubit>().deleteCard(card);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WizzCardsScreenCubit>(
      create: (context) => WizzCardsScreenCubit(
          wizzTrainingModule: widget.wizzTrainingModule, deck: widget.deck)
        ..refreshListOfCards(),
      child: BlocBuilder<WizzCardsScreenCubit, WizzCardsScreenState>(
        builder: (context, state) {
          final bool isFromTranslationScreen =
              widget.dictionaryFromTranslationScreen != null;
          final cubit = context.read<WizzCardsScreenCubit>();
          if (isFromTranslationScreen && initial == true) {
            initial = false;
            scheduleMicrotask(() {
              _onAddCardFromTranslationScreen(context, cubit);
            });
          }
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    _onBackPressed(context);
                  },
                ),
                title: Text(state.deck.name.toCapital()),
              ),
              floatingActionButton: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  _onClickAddCard(context, cubit);
                },
                child: const Icon(Icons.add),
              ),
              body: BlocListener<WizzCardsScreenCubit, WizzCardsScreenState>(
                listener: (context, state) {
                  if (state.errorMessage != null) {
                    buildInfoSnackBar(context, state.errorMessage!);
                  }
                },
                child: state.listOfCards.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          if (index >= state.listOfCards.length) {
                            return const SizedBox();
                          }
                          final card = state.listOfCards[index];
                          return Card(
                            key: ValueKey(card.word),
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    card.word,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .fontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    card.meaning,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () {
                                          _onClickEditDeck(
                                              context, cubit, card);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _onDeleteCard(context, card),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: state.listOfCards.length + 1,
                      )
                    : Center(
                        child: Text(
                            'No cards in ${state.deck.name.toCapital()} yet'),
                      ),
              ));
        },
      ),
    );
  }
}

// ListView.builder(
// itemBuilder: (context, index) {
// final card = state.listOfCards[index];
// return Card(
// key: ValueKey(card.word),
// child: Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 5.0, vertical: 10),
// child: ListTile(
// title: Text(
// card.word,
// style: const TextStyle(
// fontWeight: FontWeight.bold),
// ),
// subtitle: Text(
// card.meaning,
// maxLines: 2,
// overflow: TextOverflow.ellipsis,
// ),
// trailing: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// IconButton(
// icon: const Icon(Icons.edit_outlined),
// onPressed: () {
// _onClickEditDeck(context, cubit, card);
// },
// ),
// IconButton(
// icon: const Icon(Icons.delete),
// onPressed: () =>
// _onDeleteCard(context, card),
// ),
// ],
// ),
// ),
// ),
// );
// },
// itemCount: state.listOfCards.length,
// )
