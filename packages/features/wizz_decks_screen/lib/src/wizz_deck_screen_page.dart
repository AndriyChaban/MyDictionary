import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wizz_decks_screen/src/components/create_import_deck_fab.dart';

import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:domain_models/domain_models.dart';
import 'package:components/components.dart';

import './components/add_edit_wizz_deck_dialog.dart';
import 'wizz_deck_screen_cubit.dart';
import 'wizz_deck_screen_state.dart';

class WizzDecksScreen extends StatefulWidget {
  const WizzDecksScreen(
      {Key? key,
      required this.wizzTrainingModule,
      required this.pop,
      // this.dictionary,
      required this.addRouteListener,
      required this.removeRouteListener,
      this.dictionaryFromTranslationScreen,
      required this.scaffoldKey,
      required this.backToSearchWordScreen,
      required this.pushToWizzCardsScreen,
      required this.onPressedStartLearning})
      : super(key: key);
  static const routeName = 'wizz-decks';

  final WizzTrainingModule wizzTrainingModule;
  // final DictionaryDM? dictionary;
  final Function(BuildContext, dynamic) pushToWizzCardsScreen;
  final Function(BuildContext, dynamic) pop;
  final Function(BuildContext, VoidCallback) addRouteListener;
  final Function(BuildContext, VoidCallback) removeRouteListener;
  final Function(BuildContext, String) backToSearchWordScreen;
  final Function(BuildContext, WizzDeckDM, bool, int) onPressedStartLearning;
  final DictionaryDM? dictionaryFromTranslationScreen;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<WizzDecksScreen> createState() => _WizzDecksScreenState();
}

class _WizzDecksScreenState extends State<WizzDecksScreen> {
  late String? fromLanguage;
  late String? toLanguage;

  @override
  void initState() {
    super.initState();
    // if(widget.dictionaryFromTranslationScreen!=null) {
    fromLanguage = widget.dictionaryFromTranslationScreen?.indexLanguage;
    toLanguage = widget.dictionaryFromTranslationScreen?.contentLanguage;
    // }
  }

  void _onClickAddDeckButton(
      BuildContext context, WizzDeckScreenCubit cubit) async {
    final response = await showDialog<WizzDeckDM>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddEditWizzDeckDialog(
              dictionary: widget.dictionaryFromTranslationScreen,
              deck: null,
              fromLanguage: fromLanguage,
              toLanguage: toLanguage,
              nameValidator: (name, fromLanguage, toLanguage) async {
                final response = await cubit.validateNameOfDeck(
                    name: name,
                    fromLanguage: fromLanguage,
                    toLanguage: toLanguage);
                return response;
              },
              popCallback: widget.pop,
            ));
    if (response != null) {
      cubit.createNewWizzDeck(response);
    }
  }

  void _onClickEditDeck(BuildContext context, WizzDeckScreenCubit cubit,
      WizzDeckDM oldDeck) async {
    Navigator.pop(context);
    final newDeck = await showDialog<WizzDeckDM>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddEditWizzDeckDialog(
              dictionary: null,
              deck: oldDeck,
              nameValidator: (name, fromLanguage, toLanguage) async {
                final response = await cubit.validateNameOfDeck(
                    name: name,
                    fromLanguage: fromLanguage,
                    toLanguage: toLanguage);
                // print(response);
                return response;
              },
              popCallback: widget.pop,
            ));
    if (newDeck != null) {
      cubit.editWizzDeck(oldDeck: oldDeck, newDeck: newDeck);
    }
  }

  void _onClickExportDeck(
      BuildContext context, WizzDeckScreenCubit cubit, WizzDeckDM deck) {
    Navigator.pop(context);
    if (deck.cards.isEmpty) {
      buildInfoSnackBar(context, 'No card in deck');
    } else {
      cubit.exportWizzDeck(deck);
    }
  }

  void _onClickImportDeck(WizzDeckScreenCubit cubit) async {
    try {
      await cubit.importWizzDeck();
    } on XmlFileParsingKeyExistsException {
      final response = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmCancelDialog(
              title: 'This deck already exists',
              message: 'Do you want to overwrite?',
              onCancel: () => widget.pop(context, false),
              onConfirm: () => widget.pop(context, true)));
      if (response == true) {
        cubit.importWizzDeck(force: true);
      }
    }
  }

  void _onClickDeckTile(BuildContext context, WizzDeckDM deck) {
    bool isFirst = true;
    void refresh() {
      if (!isFirst) {
        context.read<WizzDeckScreenCubit>().getListOfAvailableDecks();
        widget.removeRouteListener(context, refresh);
      }
      isFirst = false;
    }

    widget.addRouteListener(context, refresh);
    widget.pushToWizzCardsScreen(context, {
      'deck': deck,
      'dictionaryFromTranslationScreen': widget.dictionaryFromTranslationScreen
    });
  }

  Future<bool?> _onConfirmDismiss(DismissDirection direction) async {
    final response = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext context) {
        return ConfirmCancelDialog(
            title: 'Are you sure?',
            onCancel: () => widget.pop(context, false),
            onConfirm: () => widget.pop(context, true));
      },
    );
    return response;
  }

  void _onTapMenu() {
    widget.scaffoldKey.currentState?.openDrawer();
  }

  void _backToSearchWordScreen(BuildContext context) {
    final word = widget.dictionaryFromTranslationScreen?.cards.first.headword;
    if (word != null) widget.backToSearchWordScreen(context, word);
  }

  void _onStartTraining(
      BuildContext context, WizzDeckDM deck, bool isDirectLearning, int index) {
    if (deck.cards.isEmpty) {
      buildInfoSnackBar(context, '${deck.name} is Empty');
    } else {
      widget.onPressedStartLearning(context, deck, isDirectLearning, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFromTranslationScreen =
        widget.dictionaryFromTranslationScreen != null;
    return BlocProvider<WizzDeckScreenCubit>(
      create: (context) =>
          WizzDeckScreenCubit(wizzTrainingModule: widget.wizzTrainingModule)
            ..getListOfAvailableDecks(
                fromLanguage: fromLanguage, toLanguage: toLanguage),
      child: WillPopScope(
        onWillPop: () async {
          if (isFromTranslationScreen) _backToSearchWordScreen(context);
          return false;
        },
        child: BlocBuilder<WizzDeckScreenCubit, WizzDeckScreenState>(
            builder: (context, state) {
          final cubit = context.read<WizzDeckScreenCubit>();
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Stack(
            children: [
              Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        isDark ? kAppBarColorDarkMode : kAppBarColorLightMode,
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: _onTapMenu,
                    ),
                    title: Row(
                      crossAxisAlignment: isFromTranslationScreen
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Decks:',
                        ),
                        const SizedBox(width: 5),
                        Row(
                          children: [
                            isFromTranslationScreen
                                ? Text(
                                    widget.dictionaryFromTranslationScreen!
                                        .indexLanguage
                                        .toCapital(),
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize),
                                  )
                                : DropdownButton<String>(
                                    value: state.fromLanguage,
                                    alignment: Alignment.center,
                                    underline: Container(),
                                    selectedItemBuilder: (context) {
                                      return ['all', ...klistIfLanguages]
                                          .map((lang) => Center(
                                                child: Text(
                                                  lang.toCapital(),
                                                  // style: TextStyle(
                                                  //     color: Theme.of(context)
                                                  //         .canvasColor),
                                                ),
                                              ))
                                          .toList();
                                    },
                                    items: [
                                      ...['all', ...klistIfLanguages]
                                          .map((l) => DropdownMenuItem(
                                                value: l,
                                                child: Center(
                                                  child: Text(
                                                    l.toCapital(),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ))
                                          .toList()
                                    ],
                                    onChanged: (val) {
                                      fromLanguage = val;
                                      cubit.getListOfAvailableDecks(
                                          fromLanguage: val!);
                                    },
                                  ),
                            const Icon(Icons.arrow_forward, size: 20),
                            isFromTranslationScreen
                                ? Text(
                                    widget.dictionaryFromTranslationScreen!
                                        .contentLanguage
                                        .toCapital(),
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize),
                                  )
                                : DropdownButton<String>(
                                    value: state.toLanguage,
                                    alignment: Alignment.center,
                                    underline: Container(),
                                    selectedItemBuilder: (context) {
                                      return ['all', ...klistIfLanguages]
                                          .map((lang) => Center(
                                                child: Text(
                                                  lang.toCapital(),
                                                  // style: TextStyle(
                                                  //     color: Theme.of(context)
                                                  //         .canvasColor),
                                                ),
                                              ))
                                          .toList();
                                    },
                                    items: [
                                      ...['all', ...klistIfLanguages]
                                          .map((l) => DropdownMenuItem(
                                                value: l,
                                                alignment: Alignment.center,
                                                child: Center(
                                                  child: Text(
                                                    l.toCapital(),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ))
                                          .toList()
                                    ],
                                    onChanged: (val) {
                                      toLanguage = val;
                                      cubit.getListOfAvailableDecks(
                                          toLanguage: val!);
                                    },
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: CreateImportDeckFAB(
                      onClickCreateDeck: () =>
                          _onClickAddDeckButton(context, cubit),
                      onClickImportDeck: () => _onClickImportDeck(cubit),
                      isFromTranslationScreen: isFromTranslationScreen),
                  body: BlocListener<WizzDeckScreenCubit, WizzDeckScreenState>(
                    listener: (context, state) {
                      if (state.errorMessage != null) {
                        buildInfoSnackBar(context, state.errorMessage!);
                      }
                    },
                    child: state.listOfDecks!.isEmpty &&
                            widget.dictionaryFromTranslationScreen == null
                        ? Center(
                            child: Text(
                                'No ${state.fromLanguage.toCapital()} to ${state.toLanguage.toCapital()} decks'),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.dictionaryFromTranslationScreen !=
                                  null)
                                Container(
                                  color: Colors.black54,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Please pick the deck or create new',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                _backToSearchWordScreen(
                                                    context),
                                            icon: Icon(Icons.clear,
                                                color: Theme.of(context)
                                                    .canvasColor))
                                      ],
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: state.listOfDecks != null
                                      ? state.listOfDecks!.length + 1
                                      : 0,
                                  padding: const EdgeInsets.all(5),
                                  itemBuilder: (context, index) {
                                    if (index >= state.listOfDecks!.length) {
                                      return const SizedBox(height: 80);
                                    }
                                    final deck = state.listOfDecks![index];
                                    return Dismissible(
                                      key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) =>
                                          cubit.deleteWizzDeck(deck),
                                      confirmDismiss: _onConfirmDismiss,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.red,
                                              Colors.red,
                                              Colors.red.withOpacity(0.0)
                                            ],
                                            stops: const [0, 0.5, 1],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'Delete deck',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 30),
                                            Lottie.asset(
                                              'assets/icons/delete.json',
                                              // width: 200,
                                              height: 40,
                                              width: 40,
                                              alignment: Alignment.center,
                                              fit: BoxFit.fill,
                                              // controller: _iconFavoriteController,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 10),
                                          child: ListTile(
                                            title: Hero(
                                              tag: 'deck-name-$index',
                                              child: Text(
                                                deck.name.toCapital(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${deck.fromLanguage.toCapital()} - ${deck.toLanguage.toCapital()}\n'
                                                  '${deck.cards.length} ${deck.cards.length != 1 ? 'entries' : 'entry'}\n'
                                                  '${deck.sessionNumber} training session${deck.sessionNumber != 1 ? 's' : ''}',
                                                  textAlign: TextAlign.left,
                                                ),
                                                if (!isFromTranslationScreen)
                                                  const DividerCommon(),
                                                if (!isFromTranslationScreen)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap: () =>
                                                            _onStartTraining(
                                                                context,
                                                                deck,
                                                                true,
                                                                index),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .play_circle_fill_rounded,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              Text(
                                                                  ' ${deck.fromLanguage.substring(0, 2).toCapital()}'),
                                                              const Icon(
                                                                Icons
                                                                    .arrow_forward,
                                                                size: 20,
                                                              ),
                                                              Text(deck
                                                                  .toLanguage
                                                                  .substring(
                                                                      0, 2)
                                                                  .toCapital())
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () =>
                                                            _onStartTraining(
                                                                context,
                                                                deck,
                                                                false,
                                                                index),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          // decoration:
                                                          //     BoxDecoration(
                                                          //         borderRadius:
                                                          //             BorderRadius
                                                          //                 .circular(
                                                          //                     15),
                                                          //         border:
                                                          //             Border.all(
                                                          //           width: 2,
                                                          //           color: Colors
                                                          //               .green,
                                                          //         )),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .play_circle_fill_rounded,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              Text(
                                                                  ' ${deck.fromLanguage.substring(0, 2).toCapital()}'),
                                                              const Icon(
                                                                Icons
                                                                    .arrow_back,
                                                                size: 20,
                                                              ),
                                                              Text(deck
                                                                  .toLanguage
                                                                  .substring(
                                                                      0, 2)
                                                                  .toCapital())
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ],
                                            ),
                                            trailing:
                                                widget.dictionaryFromTranslationScreen ==
                                                        null
                                                    ? PopupMenuButton(
                                                        itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem(
                                                              child: TextButton
                                                                  .icon(
                                                            icon: const Icon(Icons
                                                                .edit_outlined),
                                                            label: const Text(
                                                                'Edit'),
                                                            onPressed: () {
                                                              _onClickEditDeck(
                                                                  context,
                                                                  cubit,
                                                                  deck);
                                                            },
                                                          )),
                                                          PopupMenuItem(
                                                              child: TextButton
                                                                  .icon(
                                                            icon: const Icon(Icons
                                                                .file_upload_outlined),
                                                            label: const Text(
                                                                'Export'),
                                                            onPressed: () {
                                                              _onClickExportDeck(
                                                                  context,
                                                                  cubit,
                                                                  deck);
                                                            },
                                                          )),
                                                        ];
                                                      })
                                                    : null,
                                            onTap: () =>
                                                _onClickDeckTile(context, deck),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    // return const DividerCommon();
                                    return Container();
                                  },
                                ),
                              ),
                            ],
                          ),
                  )),
              if (state.isLoading) const CenteredLoadingProgressIndicator()
            ],
          );
        }),
      ),
    );
  }
}
