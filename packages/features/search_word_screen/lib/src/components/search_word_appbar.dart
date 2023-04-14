import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../search_word_screen_bloc.dart';

// import '../settings_state.dart';

class SearchWordAppBar extends AppBar {
  SearchWordAppBar({
    Key? key,
    required this.scaffoldKey,
    required this.searchFocusNode,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FocusNode searchFocusNode;

  @override
  State<SearchWordAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<SearchWordAppBar> {
  // Color dropDownTextColor;

  void _onSwapLanguages() {
    context
        .read<SearchWordScreenBloc>()
        .add(const SearchWordScreenEventSwapLanguages());
  }

  void _onLanguageToChanged(BuildContext context, String languageTo) {
    context
        .read<SearchWordScreenBloc>()
        .add(SearchWordScreenEventLanguageToChanged(languageTo));
  }

  void _onLanguageFromChanged(BuildContext context, String languageFrom) {
    context
        .read<SearchWordScreenBloc>()
        .add(SearchWordScreenEventLanguageFromChanged(languageFrom));
  }

  void _onTapMenu() {
    widget.scaffoldKey.currentState?.openDrawer();
    widget.searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchWordScreenBloc, SearchWordScreenState>(
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
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _onTapMenu,
          ),
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
                              .read<SearchWordScreenBloc>()
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
                            .read<SearchWordScreenBloc>()
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
                            .read<SearchWordScreenBloc>()
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
                          .read<SearchWordScreenBloc>()
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
