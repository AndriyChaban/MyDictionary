import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:translation_screen/src/translation_screen_state.dart';
import 'package:user_repository/user_repository.dart';
import 'package:components/components.dart';

import 'components/small_translation_box.dart';
import 'translation_screen_cubit.dart';
import 'components/styled_translation_card.dart';

class TranslationScreen extends StatelessWidget {
  final String word;
  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  final void Function(String) onWordClicked;
  final VoidCallback onAppBarBackPressed;
  final void Function(BuildContext, DictionaryDM) onAddCardToWizzDeck;

  const TranslationScreen({
    Key? key,
    required this.word,
    required this.onWordClicked,
    required this.onAppBarBackPressed,
    required this.dictionaryProvider,
    required this.userRepository,
    required this.onAddCardToWizzDeck,
  }) : super(key: key);

  static const routeName = 'translation-screen';

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return BlocProvider<TranslationScreenCubit>(
      create: (context) => TranslationScreenCubit(
          userRepository: userRepository,
          dictionaryProvider: dictionaryProvider)
        ..getWordTranslations(word),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: onAppBarBackPressed,
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            title: Text(word),
            actions: [
              PopupMenuButton(itemBuilder: (context) {
                return [
                  const PopupMenuItem(child: Text('item 1')),
                  const PopupMenuItem(child: Text('item 2'))
                ];
              })
            ],
          ),
          body: BlocBuilder<TranslationScreenCubit, TranslationScreenState>(
            builder: (context, state) {
              final listOfDicts = state.listOfDictionariesWithTranslations;
              final screenSize = MediaQuery.of(context).size;
              final renderBox = state.smallBoxParameters?.renderBox;
              if (state.isLoading) {
                return const CenteredLoadingProgressIndicator();
              }
              if (listOfDicts == null || listOfDicts.isEmpty) {
                return const Center(
                  child: Text(
                    'No translation\n\nProbably the dictionary was deactivated',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return WillPopScope(
                onWillPop: () async {
                  if (renderBox != null) {
                    context.read<TranslationScreenCubit>().removeSmallBox();
                    return false;
                  }
                  return true;
                },
                child: GestureDetector(
                  onTap: () {
                    context.read<TranslationScreenCubit>().removeSmallBox();
                  },
                  child: Stack(
                    children: [
                      ListView.separated(
                        itemBuilder: (context, index) => StyledTranslationCard(
                            isShort: false,
                            index: index,
                            onWordClick: onWordClicked,
                            onAddToWizzDeck: () {
                              // context.read<TranslationScreenCubit>().close();
                              onAddCardToWizzDeck(context, listOfDicts[index]);
                            },
                            headword: listOfDicts[index].cards.first.headword,
                            text: listOfDicts[index].cards.first.text,
                            dictionaryName: listOfDicts[index].name),
                        itemCount: listOfDicts.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Container(),
                      ),
                      if (renderBox != null)
                        Positioned(
                            top: renderBox
                                .localToGlobal(const Offset(0, -75))
                                .dy,
                            left: renderBox.localToGlobal(Offset.zero).dx <
                                    screenSize.width / 2
                                ? renderBox.localToGlobal(Offset.zero).dx
                                : renderBox.localToGlobal(Offset.zero).dx +
                                    renderBox.size.width -
                                    200,
                            child: SmallTranslationBox(
                                word: state.smallBoxParameters!.text,
                                translation:
                                    state.smallBoxParameters!.translation,
                                onClick: () {
                                  if (state.smallBoxParameters?.translation !=
                                      null) {
                                    onWordClicked(
                                        state.smallBoxParameters!.text);
                                    context
                                        .read<TranslationScreenCubit>()
                                        .removeSmallBox();
                                  }
                                }))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
