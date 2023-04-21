import 'package:components/components.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer(
      {Key? key,
      this.onAddDictionary,
      required this.onPressedManageDictionaries,
      required this.onPressedTranslateWord,
      required this.onPressedWizzDecks})
      : super(key: key);

  final Function()? onAddDictionary;
  final void Function(BuildContext) onPressedManageDictionaries;
  final void Function(BuildContext) onPressedTranslateWord;
  final void Function(BuildContext) onPressedWizzDecks;

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

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Theme.of(context).canvasColor);
    const headersStyle = TextStyle(color: Colors.orange, fontSize: 15);
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
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
                    icon: Icon(
                      Icons.translate,
                      color: Theme.of(context).canvasColor,
                    ),
                    label: Text(
                      'Translate word',
                      style: style,
                    ),
                  ),
                  const DividerCommon(),
                  const Text('Dictionaries', style: headersStyle),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _onInstalledDictionariesTap(context),
                    icon: Icon(
                      Icons.library_add_check,
                      color: Theme.of(context).canvasColor,
                    ),
                    label: Text(
                      'Manage Dictionaries',
                      style: style,
                    ),
                  ),
                  const DividerCommon(),
                  const Text('Wizz Decks', style: headersStyle),
                  ElevatedButton.icon(
                    onPressed: () => _onWizzDeckPush(context),
                    style: ElevatedButton.styleFrom(
                        elevation: 15,
                        backgroundColor: headersStyle.color,
                        shape: const StadiumBorder()),
                    icon: Icon(
                      Icons.wind_power_rounded,
                      color: Theme.of(context).canvasColor,
                    ),
                    label: Text(
                      'Manage Training Wizz Decks',
                      style: style,
                    ),
                  ),
                  const DividerCommon(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).canvasColor,
                    ),
                    label: Text(
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
