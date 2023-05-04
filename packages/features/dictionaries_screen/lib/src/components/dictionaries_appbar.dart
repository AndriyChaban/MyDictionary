import 'package:components/components.dart';
import 'package:dictionaries_screen/src/dictionaries_screen_cubit.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionariesAppBar extends StatefulWidget implements PreferredSizeWidget {
  // final void Function(BuildContext, String)? onLanguageFromChanged;
  // final void Function(BuildContext, String)? onLanguageToChanged;
  // final void Function()? onSwapLanguages;
  final String? fromLanguage;
  final String? toLanguage;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DictionariesAppBar({
    this.fromLanguage,
    this.toLanguage,
    required this.scaffoldKey,
    super.key,
  });

  @override
  State<DictionariesAppBar> createState() => _DictionariesAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
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

  void _onTapMenu(BuildContext context) {
    widget.scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DictionaryScreenCubit, DictionariesScreenState>(
        builder: (context, state) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return AppBar(
        titleSpacing: 5,
        backgroundColor: isDark ? kAppBarColorDarkMode : kAppBarColorLightMode,
        // leadingWidth: 40,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Installed dictionaries',
              style: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.headlineSmall!.fontSize),
              // textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 4,
                  child: DropdownButton<String>(
                      isDense: true,
                      value: state.dictionaryList.isEmpty
                          ? defaultLang
                          : state.fromLanguage ?? defaultLang,
                      alignment: Alignment.center,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize),
                      underline: Container(),
                      // dropdownColor: Theme.of(context).canvasColor,
                      selectedItemBuilder: (context) {
                        return state.fromLanguages
                            .map((lang) => Center(
                                  child: Text(
                                    lang.toCapital(),
                                    // style: TextStyle(
                                    //     color: Theme.of(context).canvasColor),
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
                IconButton(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.zero,
                    onPressed: state.isSwappable ? _onSwapLanguages : null,
                    icon: const Icon(Icons.compare_arrows_outlined)),
                Flexible(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: DropdownButton<String>(
                        isDense: true,
                        alignment: Alignment.center,
                        value: state.dictionaryList.isEmpty
                            ? defaultLang
                            : state.toLanguage?.toLowerCase() ?? defaultLang,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize),
                        underline: Container(),
                        // dropdownColor: Colors.white,
                        selectedItemBuilder: (context) {
                          return state.toLanguages
                              .map((lang) => Center(
                                    child: Text(
                                      lang.toCapital(),
                                      // style: TextStyle(
                                      //     color: Theme.of(context).canvasColor),
                                    ),
                                  ))
                              .toList();
                        },
                        items: state.toLanguages
                            .map((lang) => DropdownMenuItem(
                                  value: lang.toLowerCase(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
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
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _onTapMenu(context);
          },
        ),
        // actions: [
        //   IconButton(
        //       onPressed: _onPressedAddDictionary, icon: const Icon(Icons.add))
        // ],
      );
    });
  }
}
