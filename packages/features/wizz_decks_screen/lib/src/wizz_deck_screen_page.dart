import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:wizz_training_module/wizz_training_module.dart';
import 'package:domain_models/domain_models.dart';
import 'package:components/components.dart';

import './components/add_edit_wizz_deck_dialog.dart';
import 'wizz_deck_screen_cubit.dart';
import 'wizz_deck_screen_state.dart';

class WizzDecksScreenPage extends StatefulWidget {
  const WizzDecksScreenPage(
      {Key? key,
      required this.pushToNamed,
      required this.goToNamed,
      required this.wizzTrainingModule,
      required this.pop,
      // this.dictionary,
      required this.addRouteListener,
      required this.removeRouteListener,
      this.dictionaryFromTranslationScreen})
      : super(key: key);
  static const routeName = 'wizz-decks';

  final WizzTrainingModule wizzTrainingModule;
  // final DictionaryDM? dictionary;
  final Function(BuildContext, String, {dynamic payload}) pushToNamed;
  final Function(BuildContext, String, {dynamic payload}) goToNamed;
  final Function(BuildContext, dynamic) pop;
  final Function(BuildContext, VoidCallback) addRouteListener;
  final Function(BuildContext, VoidCallback) removeRouteListener;
  final DictionaryDM? dictionaryFromTranslationScreen;

  @override
  State<WizzDecksScreenPage> createState() => _WizzDecksScreenPageState();
}

class _WizzDecksScreenPageState extends State<WizzDecksScreenPage> {
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
    print(fromLanguage);
    print(toLanguage);
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
                // print(response);
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
      // print(oldDeck);
      // print(newDeck);
      cubit.editWizzDeck(oldDeck: oldDeck, newDeck: newDeck);
    }
  }

  void _onClickDeckTile(BuildContext context, WizzDeckDM deck) async {
    void refresh() {
      context.read<WizzDeckScreenCubit>().getListOfAvailableDecks();
      widget.removeRouteListener(context, refresh);
    }

    widget.addRouteListener(context, refresh);
    widget.pushToNamed(context, 'wizz-cards', payload: {
      'deck': deck,
      'dictionaryFromTranslationScreen': widget.dictionaryFromTranslationScreen
    });
  }

  void _onAddDictionary(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: 'Pick *.dsl file',
    );
    if (result != null && mounted) {
      context.read<WizzDeckScreenCubit>().addDictionary(result.paths.first!);
    }
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

  @override
  Widget build(BuildContext context) {
    final bool isFromTranslationScreen =
        widget.dictionaryFromTranslationScreen != null;
    // FocusScope.of(context)
    //   //   ..requestFocus()
    //   ..unfocus();
    return BlocProvider<WizzDeckScreenCubit>(
      create: (context) =>
          WizzDeckScreenCubit(wizzTrainingModule: widget.wizzTrainingModule)
            ..getListOfAvailableDecks(
                fromLanguage: fromLanguage, toLanguage: toLanguage),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: BlocBuilder<WizzDeckScreenCubit, WizzDeckScreenState>(
            builder: (context, state) {
          final cubit = context.read<WizzDeckScreenCubit>();
          // print(widget.dictionaryFromTranslationScreen);
          return Stack(
            children: [
              Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    // leadingWidth: 30,
                    title: Row(
                      crossAxisAlignment: isFromTranslationScreen
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    selectedItemBuilder: (context) {
                                      return ['all', ...klistIfLanguages]
                                          .map((lang) => Center(
                                                child: Text(
                                                  lang.toCapital(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .canvasColor),
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
                                    selectedItemBuilder: (context) {
                                      return ['all', ...klistIfLanguages]
                                          .map((lang) => Center(
                                                child: Text(
                                                  lang.toCapital(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .canvasColor),
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
                    // leading: IconButton(
                    //   onPressed: () => widget.pop(context, null),
                    //   icon: const Icon(Icons.arrow_back_rounded),
                    // ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => _onClickAddDeckButton(context, cubit),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.add),
                  ),
                  drawer: MainDrawer(
                    goToNamed: widget.goToNamed,
                    pushToNamed: widget.pushToNamed,
                    onAddDictionary: () => _onAddDictionary(context),
                    onPressedManageDictionaries: (BuildContext) {},
                    onPressedTranslateWord: (BuildContext) {},
                  ),
                  body: BlocListener<WizzDeckScreenCubit, WizzDeckScreenState>(
                    listener: (context, state) {
                      if (state.errorMessage != null) {
                        buildInfoSnackBar(context, state.errorMessage!);
                      }
                    },
                    child: state.listOfDecks!.isEmpty
                        ? Center(
                            child: Text(
                                'No decks for ${state.fromLanguage.toCapital()} → ${state.toLanguage.toCapital()} yet'),
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
                                          'Please pick a dictionary',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                widget.pop(context, null),
                                            icon: Icon(Icons.clear,
                                                color: Theme.of(context)
                                                    .canvasColor))
                                      ],
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: state.listOfDecks?.length ?? 0,
                                  padding: const EdgeInsets.all(5),
                                  itemBuilder: (context, index) {
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
                                              horizontal: 5.0, vertical: 10),
                                          child: ListTile(
                                            title: Text(
                                              deck.name.toUpperCase(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                                '${deck.fromLanguage.toCapital()} - ${deck.toLanguage.toCapital()}\n'
                                                '${deck.cards.length} entries'),
                                            trailing:
                                                widget.dictionaryFromTranslationScreen ==
                                                        null
                                                    ? Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.start),
                                                            onPressed: () {},
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(Icons
                                                                .edit_outlined),
                                                            onPressed: () {
                                                              _onClickEditDeck(
                                                                  context,
                                                                  cubit,
                                                                  deck);
                                                            },
                                                          ),
                                                        ],
                                                      )
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
