import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/src/components/search_bar.dart';
import 'package:main_screen/src/main_screen_bloc.dart';
import 'package:main_screen/src/main_screen_event.dart';

import '../main_screen_state.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key, required this.onWordClicked}) : super(key: key);

  final void Function(BuildContext, String, MainScreenBloc) onWordClicked;
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
    // print('controller: ${_searchController.text}');
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchControllerListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_searchBarFocusNode);
    });
  }

  void _searchControllerListener() {
    _onSearchTermChanged(context);
  }

  void _onWordClicked(String word) =>
      widget.onWordClicked(context, word, context.read<MainScreenBloc>());

  @override
  void dispose() {
    _searchController.dispose();
    _searchBarFocusNode.dispose();
    _searchController.removeListener(_searchControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
            controller: _searchController,
            // onChanged: (String val) => _onSearchTermChanged(context),
            focusNode: _searchBarFocusNode),
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
                  return StyledTranslationCard(
                    headword: results[index].headword,
                    text: results[index].text,
                    isShort: true,
                    onClick: _onWordClicked,
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
  }
}
