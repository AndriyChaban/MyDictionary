import 'package:flashcards_screen/src/components/complete_training_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';

import './components/flipping_cards.dart';
import './components/animated_progress_bar.dart';
import 'components/flash_cards_screen_appbar.dart';
import 'flashcards_screen_cubit.dart';

class FlashCardsScreen extends StatefulWidget {
  const FlashCardsScreen(
      {Key? key,
      required this.deck,
      required this.wizzTrainingModule,
      required this.scaffoldKey,
      this.isDirectLearning = true,
      required this.index,
      required this.pop,
      required this.goToWizzDeckPage,
      required this.pushToSimpleTranslationCard})
      : super(key: key);
  final WizzDeckDM deck;
  final WizzTrainingModule wizzTrainingModule;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isDirectLearning;
  final int index;
  final void Function(BuildContext, dynamic) pop;
  final void Function(BuildContext) goToWizzDeckPage;
  final void Function(BuildContext, dynamic) pushToSimpleTranslationCard;

  static const routeName = 'flash-cards-screen';

  @override
  State<FlashCardsScreen> createState() => _FlashCardsScreenState();
}

class _FlashCardsScreenState extends State<FlashCardsScreen> {
  // bool showFront = false;
  // String assetPath1 = 'assets/pictures/drawer_picture.jpg';
  // String assetPath2 = 'assets/pictures/flip_card_side.jpg';

  final PageController _pageController = PageController(initialPage: 0);

  void _onTapMenu() {
    widget.scaffoldKey.currentState?.openDrawer();
  }

  void _onPressedOk(BuildContext context, int index, bool isOk) {
    final cubit = context.read<FlashCardsScreenCubit>();
    cubit.updateCard(cubit.state.listOfCards[index], isOk);
    if (index < cubit.state.listOfCards.length - 1) {
      _animateToNextPage();
    } else {
      _completeTraining(context);
    }
  }

  void _animateToNextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic);
  }

  Future<bool> _stopTraining() async {
    final response = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext context) {
        return ConfirmCancelDialog(
            title: 'Stop training?',
            message: 'All progress will be lost.',
            onCancel: () => widget.pop(context, false),
            onConfirm: () => widget.pop(context, true));
      },
    );
    if (response == true && mounted) {
      widget.goToWizzDeckPage(context);
      return true;
    }
    return false;
  }

  void _completeTraining(BuildContext context) async {
    final cubit = context.read<FlashCardsScreenCubit>();
    cubit.completeTraining();
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CompleteTrainingDialog(
            listOfCards: cubit.state.listOfCards,
            onPressedOk: () => widget.pop(context, false),
            numberOfSuccesses: cubit.numberOfSuccesses));
    if (mounted) {
      widget.goToWizzDeckPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlashCardsScreenCubit>(
      create: (context) => FlashCardsScreenCubit(
          wizzTrainingModule: widget.wizzTrainingModule, deck: widget.deck)
        ..createListOfCards(),
      child: WillPopScope(
        onWillPop: () async {
          return await _stopTraining();
        },
        child: BlocBuilder<FlashCardsScreenCubit, FlashCardsScreenState>(
            builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: FlashCardsScreenAppBar(
                    deck: widget.deck,
                    onTapMenu: _onTapMenu,
                    index: widget.index),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: _stopTraining,
                  // backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.stop,
                    // color: Colors.white,
                  ),
                ),
                // bottomNavigationBar: Container(
                //   color: Colors.white,
                //   height: 50,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       TextButton(
                //           onPressed: () {}, child: const Text('Show Examples')),
                //       TextButton(
                //           onPressed: () {},
                //           child: const Text('Show Full Text')),
                //     ],
                //   ),
                // ),
                // backgroundColor: Colors.black54,
                body: BlocBuilder<FlashCardsScreenCubit, FlashCardsScreenState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedProgressBar(
                          maxValue: state.listOfCards.length,
                          currentValue: state.currentProgress,
                        ),
                        Expanded(
                          // flex: 7,
                          // fit: FlexFit.loose,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.listOfCards.length,
                            itemBuilder: (context, index) => FlippingCards(
                              isDirectLearning: widget.isDirectLearning,
                              card: state.listOfCards[index],
                              showExamples: false,
                              onPressedOk: () =>
                                  _onPressedOk(context, index, true),
                              onPressedNotOk: () =>
                                  _onPressedOk(context, index, false),
                              onPressedShowFullText: () =>
                                  widget.pushToSimpleTranslationCard(
                                      context, state.listOfCards[index]),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              if (state.isLoading) const CenteredLoadingProgressIndicator()
            ],
          );
        }),
      ),
    );
  }
}
