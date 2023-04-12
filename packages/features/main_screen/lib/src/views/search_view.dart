import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/src/components/search_bar.dart';
import 'package:main_screen/src/main_screen_bloc.dart';
import 'package:main_screen/src/main_screen_event.dart';

import '../components/styled_translation_card.dart';
import '../main_screen_state.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key, required this.onWordClicked}) : super(key: key);

  final void Function(BuildContext, String) onWordClicked;
  static const routeName = 'search-view';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();
  final _searchBarFocusNode = FocusNode();

  void _onSearchTermChanged(BuildContext context) {
    if (_searchController.text.replaceAll(RegExp(r'\s'), '').isEmpty) {
      _searchController.text = '';
    }
    BlocProvider.of<MainScreenBloc>(context)
        .add(MainScreenEventSearchTermChanged(_searchController.text));
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchControllerListener);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   FocusScope.of(context).requestFocus(_searchBarFocusNode);
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   FocusScope.of(context).unfocus();
  //   super.didChangeDependencies();
  // }

  void _searchControllerListener() {
    _onSearchTermChanged(context);
  }

  void _onWordClicked(String headword) {
    widget.onWordClicked(context, headword);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBarFocusNode.dispose();
    _searchController.removeListener(_searchControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        children: [
          BlocSelector<MainScreenBloc, MainScreenState, String>(
            selector: (state) {
              return state.searchTerm;
            },
            builder: (context, term) {
              if (term.isEmpty) _searchController.clear();
              return SearchBar(
                controller: _searchController,
                text: term,
                focusNode: _searchBarFocusNode,
              );
            },
          ),
          const Divider(
            height: 3,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          BlocSelector<MainScreenBloc, MainScreenState, List<CardDM>>(
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
    });
  }
}
