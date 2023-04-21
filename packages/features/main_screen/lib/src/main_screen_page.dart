import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_repository/user_repository.dart';
// import 'package:components/components.dart';

import 'components/main_drawer.dart';
import 'settings_cubit.dart';

class MainScreen extends StatefulWidget {
  // final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  final Widget child;
  final void Function(BuildContext) onPressedManageDictionaries;
  final void Function(BuildContext) onPressedTranslateWord;
  final void Function(BuildContext) onPressedWizzDecks;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MainScreen({
    Key? key,
    // required this.dictionaryProvider,
    required this.userRepository,
    required this.child,
    required this.onPressedManageDictionaries,
    required this.onPressedTranslateWord,
    required this.scaffoldKey,
    required this.onPressedWizzDecks,
    // required this.onTranslationSelected,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
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
      child: BlocProvider<SettingsCubit>(
        // lazy: false,
        create: (context) =>
            SettingsCubit(userRepository: widget.userRepository),
        child: Builder(
          builder: (context) {
            return
                // Stack(
                // children: [
                Scaffold(
              key: widget.scaffoldKey,
              drawer: MainDrawer(
                onPressedManageDictionaries: widget.onPressedManageDictionaries,
                onPressedTranslateWord: widget.onPressedTranslateWord,
                onPressedWizzDecks: widget.onPressedWizzDecks,
              ),
              body: widget.child,
            );
          },
        ),
      ),
    );
  }
}
