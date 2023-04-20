import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';

import './components/flipping_cards.dart';
import './components/animated_progress_bar.dart';
import 'flashcards_screen_cubit.dart';

class FlashCardsScreen extends StatefulWidget {
  const FlashCardsScreen(
      {Key? key,
      required this.deck,
      required this.wizzTrainingModule,
      required this.scaffoldKey,
      this.isDirectLearning = true,
      required this.index})
      : super(key: key);
  final WizzDeckDM deck;
  final WizzTrainingModule wizzTrainingModule;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isDirectLearning;
  final int index;

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

  void _onStopLearning() {
    setState(() {
      // showFront = !showFront;
      // assetPath = assetPath == 'assets/pictures/drawer_picture.jpg'
      //     ? assetPath2
      //     : 'assets/pictures/drawer_picture.jpg';
    });
  }

  void _onPressedOk(int index) {
    if (index < widget.deck.cards.length) {
      _animateToNextPage();
    } else {
      _stopTraining();
    }
  }

  void _onPressedNotOk(int index) {
    if (index < widget.deck.cards.length) {
      _animateToNextPage();
    } else {
      _stopTraining();
    }
  }

  void _animateToNextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic);
  }

  void _stopTraining() {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlashCardsScreenCubit>(
      create: (context) => FlashCardsScreenCubit(
          wizzTrainingModule: widget.wizzTrainingModule, deck: widget.deck)
        ..createListOfCards(),
      child: WillPopScope(
        onWillPop: () async {
          print('willpopscope');
          return false;
        },
        child: BlocBuilder<FlashCardsScreenCubit, FlashCardsScreenState>(
            builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  leading: Column(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.menu), onPressed: _onTapMenu),
                    ],
                  ),
                  title: Column(
                    children: [
                      Hero(
                          tag: 'deck-name-${widget.index}',
                          child: Text(widget.deck.name.toCapital())),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.deck.fromLanguage.toCapital()),
                          const Icon(Icons.arrow_forward_rounded),
                          Text(widget.deck.toLanguage.toCapital()),
                        ],
                      )
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: _onStopLearning,
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.stop,
                    color: Colors.white,
                  ),
                ),
                bottomNavigationBar: Container(
                  color: Colors.white,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {}, child: const Text('Show Examples')),
                      TextButton(
                          onPressed: () {},
                          child: const Text('Show Full Text')),
                    ],
                  ),
                ),
                backgroundColor: Colors.black54,
                body: BlocBuilder<FlashCardsScreenCubit, FlashCardsScreenState>(
                  builder: (context, state) {
                    // final cubit = context.read<FlashCardsScreenCubit>();
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const AnimatedProgressBar(),
                        Expanded(
                          // flex: 7,
                          // fit: FlexFit.loose,
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.deck.cards.length,
                            itemBuilder: (context, index) => FlippingCards(
                              isDirectLearning: widget.isDirectLearning,
                              card: widget.deck.cards[index],
                              showExamples: false,
                              onPressedOk: () => _onPressedOk(index),
                              onPressedNotOk: () => _onPressedNotOk(index),
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
