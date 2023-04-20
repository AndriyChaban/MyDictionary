import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:search_word_screen/src/components/search_word_appbar.dart';
import 'package:user_repository/user_repository.dart';

import 'components/search_bar.dart';
import 'search_word_screen_bloc.dart';
import 'components/short_translation_card.dart';

class SearchWordScreen extends StatefulWidget {
  static const routeName = 'search-word-screen';

  final void Function(BuildContext, String) onWordClicked;
  final UserRepository userRepository;
  final DictionaryProvider dictionaryProvider;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool requestFocus;

  const SearchWordScreen(
      {Key? key,
      required this.onWordClicked,
      required this.scaffoldKey,
      required this.userRepository,
      required this.dictionaryProvider,
      this.requestFocus = true})
      : super(key: key);

  @override
  State<SearchWordScreen> createState() => _SearchWordScreenState();
}

class _SearchWordScreenState extends State<SearchWordScreen> {
  final _searchController = TextEditingController();
  final _searchBarFocusNode = FocusNode();

  void _onSearchTermChanged(BuildContext context) {
    if (_searchController.text.replaceAll(RegExp(r'\s'), '').isEmpty) {
      _searchController.text = '';
    }
    BlocProvider.of<SearchWordScreenBloc>(context)
        .add(SearchWordScreenEventSearchTermChanged(_searchController.text));
  }

  void _onWordClicked(String headword) {
    widget.onWordClicked(context, headword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBarFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchWordScreenBloc>(
      create: (context) => SearchWordScreenBloc(
          userRepository: widget.userRepository,
          dictionaryProvider: widget.dictionaryProvider)
        ..add(const SearchWordScreenEventInitial()),
      child: Scaffold(
        appBar: SearchWordAppBar(
          scaffoldKey: widget.scaffoldKey,
          searchFocusNode: _searchBarFocusNode,
        ),
        body: Builder(builder: (context) {
          return Column(
            children: [
              BlocSelector<SearchWordScreenBloc, SearchWordScreenState, String>(
                selector: (state) {
                  return state.searchTerm;
                },
                builder: (context, term) {
                  if (term.isEmpty) _searchController.clear();
                  return SearchBar(
                    controller: _searchController,
                    text: term,
                    focusNode: _searchBarFocusNode,
                    requestFocus: widget.requestFocus,
                    onSearchTermChanged: _onSearchTermChanged,
                  );
                },
              ),
              const Divider(
                height: 3,
                thickness: 1,
                indent: 8,
                endIndent: 8,
              ),
              BlocSelector<SearchWordScreenBloc, SearchWordScreenState,
                  List<CardDM>>(
                selector: (state) {
                  return state.itemsList;
                },
                builder: (context, results) {
                  return Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return ShortTranslationCard(
                          headword: results[index].headword,
                          text: results[index].text,
                          onWordClick: _onWordClicked,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const DividerCommon(),
                      itemCount: results.length,
                    ),
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
