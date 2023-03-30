import 'package:components/components.dart';
import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/src/main_screen_state.dart';
import 'package:user_repository/user_repository.dart';

import 'components/main_appbar.dart';
import 'components/main_drawer.dart';
import 'main_screen_bloc.dart';
import 'main_screen_event.dart';

class MainScreen extends StatefulWidget {
  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  final Widget child;
  final void Function(BuildContext, String) goToView;

  // final void Function() onTranslationSelected;

  const MainScreen({
    Key? key,
    required this.dictionaryProvider,
    required this.child,
    required this.goToView,
    required this.userRepository,
    // required this.onTranslationSelected,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _onAddDictionary(BuildContext context) {
    context
        .read<MainScreenBloc>()
        .add(const MainScreenEventAddDictionary('assets/BusinessEnUk.dsl'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (_activeView != MainScreenActiveView.historyList) {
        //   setState(() {
        //     _activeView = MainScreenActiveView.historyList;
        //   });
        //   return false;
        // }
        return false;
      },
      child: BlocProvider<MainScreenBloc>(
        create: (context) => MainScreenBloc(
            dictionaryProvider: widget.dictionaryProvider,
            userRepository: widget.userRepository)
          ..add(const MainScreenEventLoadInitial()),
        child: Stack(
          children: [
            Builder(builder: (context) {
              return Scaffold(
                appBar: MainAppBar(),
                drawer: MainDrawer(
                  goToView: widget.goToView,
                  onAddDictionary: () => _onAddDictionary(context),
                ),
                body: SafeArea(
                  child: Center(child: widget.child),
                ),
              );
            }),
            BlocSelector<MainScreenBloc, MainScreenState, bool>(
              selector: (state) {
                return state.isLoading;
              },
              builder: (context, state) {
                return state
                    ? const CenteredLoadingProgressIndicator()
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum MainScreenActiveView { historyList, searchResultsList, dictionariesList }
