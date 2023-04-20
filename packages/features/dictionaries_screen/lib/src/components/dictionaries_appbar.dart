import 'package:dictionaries_screen/src/dictionaries_screen_cubit.dart';
import 'package:domain_models/domain_models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionariesAppBar extends AppBar {
  // final void Function(BuildContext, String)? onLanguageFromChanged;
  // final void Function(BuildContext, String)? onLanguageToChanged;
  // final void Function()? onSwapLanguages;
  final String? fromLanguage;
  final String? toLanguage;
  final GlobalKey<ScaffoldState> scaffoldKey;
  DictionariesAppBar({
    this.fromLanguage,
    this.toLanguage,
    required this.scaffoldKey,
    super.key,
  });

  @override
  State<DictionariesAppBar> createState() => _DictionariesAppBarState();
}

class _DictionariesAppBarState extends State<DictionariesAppBar> {
  void _onLanguageFromChanged(BuildContext context, String from) {
    context.read<DictionaryScreenCubit>().languageFromChanged(from);
  }

  void _onLanguageToChanged(BuildContext context, String to) {
    context.read<DictionaryScreenCubit>().languageToChanged(to);
  }

  void _onSwapLanguages() {
    context.read<DictionaryScreenCubit>().swapLanguages();
  }

  void _onPressedAddDictionary() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: 'Pick *.dsl file',
    );
    if (result != null && mounted) {
      context
          .read<DictionaryScreenCubit>()
          .addDictionary(result.files.single.path!);
    }
    // else {
    // User canceled the picker
    // print('null');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DictionaryScreenCubit, DictionariesScreenState>(
        builder: (context, state) {
      // bool isSwappable = state.fromLanguage != state.toLanguage &&
      //     state.dictionaryList
      //         .where((d) =>
      //             d.contentLanguage == state.fromLanguage &&
      //             d.indexLanguage == state.toLanguage)
      //         .isNotEmpty;
      // isSwappable = true;
      // final fromLanguages =
      //     context.read<DictionaryScreenCubit>().listOfAllActiveFromLanguages();
      // final toLanguages =
      //     context.read<DictionaryScreenCubit>().listOfAllActiveToLanguages();
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
                child: DropdownButton<String>(
                    value: state.dictionaryList.isEmpty
                        ? defaultLang
                        : state.fromLanguage ?? defaultLang,
                    alignment: Alignment.center,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(),
                    dropdownColor: Theme.of(context).canvasColor,
                    selectedItemBuilder: (context) {
                      return state.fromLanguages
                          .map((lang) => Center(
                                child: Text(
                                  lang.toCapital(),
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor),
                                ),
                              ))
                          .toList();
                    },
                    items: state.fromLanguages
                        .map((lang) => DropdownMenuItem(
                              value: lang,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(lang.toCapital()),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null && val.isNotEmpty) {
                        _onLanguageFromChanged(context, val);
                      }
                    }),
              ),
            ),
            IconButton(
                onPressed: state.isSwappable ? _onSwapLanguages : null,
                icon: const Icon(Icons.compare_arrows_outlined)),
            Flexible(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: DropdownButton<String>(
                    value: state.dictionaryList.isEmpty
                        ? defaultLang
                        : state.toLanguage?.toLowerCase() ?? defaultLang,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(),
                    dropdownColor: Colors.white,
                    selectedItemBuilder: (context) {
                      return state.toLanguages
                          .map((lang) => Center(
                                child: Text(
                                  lang.toCapital(),
                                  style: TextStyle(
                                      color: Theme.of(context).canvasColor),
                                ),
                              ))
                          .toList();
                    },
                    items: state.toLanguages
                        .map((lang) => DropdownMenuItem(
                              value: lang.toLowerCase(),
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            widget.scaffoldKey.currentState?.openDrawer();
            // Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
              onPressed: _onPressedAddDictionary, icon: const Icon(Icons.add))
        ],
      );
    });
  }
}
