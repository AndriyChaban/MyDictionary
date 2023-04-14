import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/src/main_screen_bloc.dart';
import 'package:main_screen/src/main_screen_event.dart';

import '../main_screen_state.dart';

class MainAppBar extends AppBar {
  MainAppBar({Key? key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  // Color dropDownTextColor;

  void _onSwapLanguages() {
    context.read<MainScreenBloc>().add(const MainScreenEventSwapLanguages());
  }

  void _onLanguageToChanged(BuildContext context, String languageTo) {
    context
        .read<MainScreenBloc>()
        .add(MainScreenEventLanguageToChanged(languageTo));
  }

  void _onLanguageFromChanged(BuildContext context, String languageFrom) {
    context
        .read<MainScreenBloc>()
        .add(MainScreenEventLanguageFromChanged(languageFrom));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      buildWhen: (previous, current) =>
          previous.fromLanguage != current.fromLanguage ||
          previous.toLanguage != current.toLanguage ||
          previous.dictionaryList != current.dictionaryList,
      builder: (context, state) {
        bool isSwappable = state.fromLanguage != state.toLanguage &&
            state.dictionaryList
                .where((d) =>
                    d.contentLanguage == state.fromLanguage &&
                    d.indexLanguage == state.toLanguage)
                .isNotEmpty;
        // print(GoRouter.of(context).location);
        // bool forceAllDicts =
        //     GoRouter.of(context).location == '/dictionaries_view';
        return AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: DropdownButton(
                      value: state.fromLanguage,
                      alignment: Alignment.center,
                      style: TextStyle(color: Colors.black),
                      underline: Container(),
                      dropdownColor: Theme.of(context).canvasColor,
                      selectedItemBuilder: (context) {
                        return [
                          if (state.fromLanguage.isEmpty) Container(),
                          ...context
                              .read<MainScreenBloc>()
                              .listOfAllActiveFromLanguages()
                              .map((lang) => Center(
                                    child: Text(
                                      lang.toCapital(),
                                      style: TextStyle(
                                          color: Theme.of(context).canvasColor),
                                    ),
                                  ))
                              .toList()
                        ];
                      },
                      items: [
                        if (state.fromLanguage.isEmpty)
                          DropdownMenuItem(
                            value: state.fromLanguage,
                            child: Container(),
                          ),
                        ...context
                            .read<MainScreenBloc>()
                            .listOfAllActiveFromLanguages()
                            .map((lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(lang.toCapital()),
                                  ),
                                ))
                            .toList()
                      ],
                      onChanged: (val) {
                        if (val != null && val.isNotEmpty) {
                          _onLanguageFromChanged(context, val);
                        }
                      }),
                ),
              ),
              IconButton(
                  onPressed: isSwappable ? _onSwapLanguages : null,
                  icon: const Icon(Icons.compare_arrows_outlined)),
              Flexible(
                flex: 4,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: DropdownButton(
                      value: state.toLanguage,
                      style: TextStyle(color: Colors.black),
                      underline: Container(),
                      dropdownColor: Colors.white,
                      selectedItemBuilder: (context) {
                        return context
                            .read<MainScreenBloc>()
                            .listOfAllActiveToLanguages()
                            .map((lang) => Center(
                                  child: Text(
                                    lang.toCapital(),
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor),
                                  ),
                                ))
                            .toList();
                      },
                      items: context
                          .read<MainScreenBloc>()
                          .listOfAllActiveToLanguages()
                          .map((lang) => DropdownMenuItem(
                                value: lang,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(lang.toCapital()),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null && val.isNotEmpty) {
                          _onLanguageToChanged(context, val);
                        }
                      }),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
