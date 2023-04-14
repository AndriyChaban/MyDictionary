import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:components/components.dart';

import 'components/main_appbar.dart';
import 'settings_cubit.dart';

class MainScreen extends StatefulWidget {
  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  final Widget child;
  final void Function(BuildContext, String, {dynamic payload}) pushToNamed;
  final void Function(BuildContext, String, {dynamic payload}) goToNamed;
  final void Function(BuildContext) onPressedManageDictionaries;
  final void Function(BuildContext) onPressedTranslateWord;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MainScreen({
    Key? key,
    required this.dictionaryProvider,
    required this.userRepository,
    required this.child,
    required this.pushToNamed,
    required this.goToNamed,
    required this.onPressedManageDictionaries,
    required this.onPressedTranslateWord,
    required this.scaffoldKey,
    // required this.onTranslationSelected,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // void _onAddDictionary(BuildContext context) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //     dialogTitle: 'Pick *.dsl file',
  //   );
  //   if (result != null && mounted) {
  //     context
  //         .read<MainScreenBloc>()
  //         .add(MainScreenEventAddDictionary(result.paths.first!));
  //     // File file = File(result.files.single.path!);
  //     // print((result.paths.first));
  //     // print(file.path);
  //   }
  //   // else {
  //   // User canceled the picker
  //   // print('null');
  //   // }
  //   // context
  //   //     .read<MainScreenBloc>()
  //   //     .add(const MainScreenEventAddDictionary('assets/BusinessEnUk.dsl'));
  // }

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
        child: Builder(builder: (context) {
          return
              // Stack(
              // children: [
              Scaffold(
            // appBar: MainAppBar(),
            key: widget.scaffoldKey,
            drawer: MainDrawer(
              pushToNamed: widget.pushToNamed,
              goToNamed: widget.goToNamed,
              onPressedManageDictionaries: widget.onPressedManageDictionaries,
              onPressedTranslateWord: widget.onPressedTranslateWord,
            ),
            body: widget.child,
            // body: BlocListener<SettingsCubit, SettingsState>(
            //   listener: (context, state) {
            //     // if (state.message.isNotEmpty) {
            //     //   buildInfoSnackBar(context, state.message);
            //     // }
            //   },
            //   child: Builder(builder: (context) {
            //     // Scaffold.of(context).closeDrawer();
            //     return Center(child: widget.child);
            //   }),
            // ),
          );
          // BlocBuilder<SettingsCubit, SettingsState>(
          //   builder: (context, state) {
          //     return state
          //         ? const CenteredLoadingProgressIndicator()
          //         : Container();
          //   },
          //     // ),
          //   ],
          // );
        }),
      ),
    );
  }
}

// enum MainScreenActiveView { historyList, searchResultsList, dictionariesList }
