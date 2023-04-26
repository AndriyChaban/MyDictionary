import 'package:components/components.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {Key? key,
      this.onAddDictionary,
      required this.onPressedManageDictionaries,
      required this.onPressedTranslateWord,
      required this.onPressedWizzDecks,
      required this.drawerWidth,
      required this.onPressedSettings})
      : super(key: key);

  final Function()? onAddDictionary;
  final void Function(BuildContext) onPressedManageDictionaries;
  final void Function(BuildContext) onPressedTranslateWord;
  final void Function(BuildContext) onPressedWizzDecks;
  final void Function(BuildContext) onPressedSettings;
  final double drawerWidth;

  void _onInstalledDictionariesTap(BuildContext context) {
    Navigator.pop(context);
    onPressedManageDictionaries(context);
  }

  void _onTranslateWordTap(BuildContext context) {
    Navigator.pop(context);
    onPressedTranslateWord(context);
  }

  void _onWizzDeckPush(BuildContext context) {
    Navigator.pop(context);
    onPressedWizzDecks(context);
  }

  void _onSettingsTap(BuildContext context) {
    Navigator.pop(context);
    onPressedSettings(context);
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white);
    const headersStyle = TextStyle(
        color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: isDark ? kAppBarColorDarkMode : kAppBarColorLightMode,
      width: drawerWidth,
      shape: const Border(),
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250,
                // pinned: true,
                leading: Container(),
                backgroundColor: Colors.white38,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset('assets/pictures/drawer_picture.jpg',
                      fit: BoxFit.cover),
                  title: const Text('MyDictionary'),
                  centerTitle: true,
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Translate', style: headersStyle),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _onTranslateWordTap(context),
                    icon: const Icon(
                      Icons.translate,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Translate word',
                      style: style,
                    ),
                  ),
                  const DividerCommon(
                    color: Colors.white38,
                  ),
                  const Text('Dictionaries', style: headersStyle),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _onInstalledDictionariesTap(context),
                    icon: const Icon(
                      Icons.library_add_check,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Manage Dictionaries',
                      style: style,
                    ),
                  ),
                  const DividerCommon(
                    color: Colors.white38,
                  ),
                  const Text('Wizz Decks', style: headersStyle),
                  ElevatedButton.icon(
                    onPressed: () => _onWizzDeckPush(context),
                    style: ElevatedButton.styleFrom(
                        elevation: 15,
                        backgroundColor: headersStyle.color,
                        shape: const StadiumBorder()),
                    icon: const Icon(
                      Icons.wind_power_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Manage Training Wizz Decks',
                      style: style,
                    ),
                  ),
                  const DividerCommon(
                    color: Colors.white38,
                  ),
                  TextButton.icon(
                    onPressed: () => _onSettingsTap(context),
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Settings',
                      style: style,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
