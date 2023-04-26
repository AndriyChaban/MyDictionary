import 'package:flutter/material.dart';

import 'package:user_repository/user_repository.dart';

import 'components/main_drawer.dart';

class MainScreen extends StatefulWidget {
  final UserRepository userRepository;
  final Widget child;
  final void Function(BuildContext) onPressedManageDictionaries;
  final void Function(BuildContext) onPressedTranslateWord;
  final void Function(BuildContext) onPressedWizzDecks;
  final void Function(BuildContext) onPressedSettings;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MainScreen({
    Key? key,
    required this.userRepository,
    required this.child,
    required this.onPressedManageDictionaries,
    required this.onPressedTranslateWord,
    required this.scaffoldKey,
    required this.onPressedWizzDecks,
    required this.onPressedSettings,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late final _drawerController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
  final double _drawerWidth = 300;

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
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
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: MainDrawer(
          drawerWidth: _drawerWidth,
          onPressedManageDictionaries: widget.onPressedManageDictionaries,
          onPressedTranslateWord: widget.onPressedTranslateWord,
          onPressedWizzDecks: widget.onPressedWizzDecks,
          onPressedSettings: widget.onPressedSettings,
        ),
        onDrawerChanged: (val) {
          if (val) {
            _drawerController.forward();
          } else {
            _drawerController.reverse();
          }
        },
        body: AnimatedBuilder(
            animation: _drawerController,
            builder: (context, child) {
              final offsetX =
                  Curves.easeInOut.transform(_drawerController.value) *
                      _drawerWidth;
              return Transform.translate(
                  offset: Offset(offsetX, 0), child: child!);
            },
            child: widget.child),
      ),
    );
  }
}
