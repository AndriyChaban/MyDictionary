import 'package:components/components.dart';
// import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:main_screen/main_screen.dart';
// import 'package:main_screen/src/main_screen_event.dart';
// import 'package:permission_handler/permission_handler.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer(
      {Key? key,
      required this.goToNamed,
      required this.pushToNamed,
      this.onAddDictionary})
      : super(key: key);

  final void Function(BuildContext, String) pushToNamed;
  final void Function(BuildContext, String, {dynamic payload}) goToNamed;
  final Function()? onAddDictionary;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  void _onAddDictionary() async {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
    if (mounted) {
      if (widget.onAddDictionary != null) widget.onAddDictionary!();
    }
  }

  // Future<void> _onDeleteDict(
  //     BuildContext context, DictionaryDM dictionaryName) async {
  //   context
  //       .read<MainScreenBloc>()
  //       .add(MainScreenEventDeleteDictionary(dictionaryName));
  // }

  void _onInstalledDictionariesTap(BuildContext context) {
    Navigator.pop(context);
    widget.goToNamed(context, 'dictionaries-view');
  }

  void _onTranslateWordTap(BuildContext context) {
    Navigator.pop(context);
    widget.goToNamed(context, 'search-view');
  }

  void _onWizzDeckPush() {
    Navigator.pop(context);
    widget.pushToNamed(context, 'wizz-decks');
  }

  @override
  Widget build(BuildContext context) {
    // FocusScope.of(context)
    //   ..requestFocus()
    //   ..unfocus();

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 300,
                // pinned: true,
                leading: Container(),
                backgroundColor: Colors.white38,
                flexibleSpace: FlexibleSpaceBar(
                  background: Icon(
                    Icons.laptop_chromebook,
                    size: 200,
                    color: Theme.of(context).colorScheme.background,
                  ),
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
                  const Text('Translate'),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _onTranslateWordTap(context),
                    icon: Icon(
                      Icons.translate,
                      color: Theme.of(context).textTheme.headlineLarge!.color,
                    ),
                    label: Text(
                      'Translate word',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                  ),
                  const DividerCommon(),
                  const Text('Dictionaries'),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _onInstalledDictionariesTap(context),
                    icon: Icon(
                      Icons.library_add_check,
                      color: Theme.of(context).textTheme.headlineLarge!.color,
                    ),
                    label: Text(
                      'Installed',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _onAddDictionary,
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.headlineLarge!.color,
                    ),
                    label: Text(
                      'Add dictionary',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                  ),
                  const DividerCommon(),
                  TextButton.icon(
                    onPressed: _onWizzDeckPush,
                    icon: Icon(
                      Icons.wind_power_rounded,
                      color: Theme.of(context).textTheme.headlineLarge!.color,
                    ),
                    label: Text(
                      'Wizz Cards',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                  ),
                  const DividerCommon(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).textTheme.headlineLarge!.color,
                    ),
                    label: Text(
                      'Settings',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge!.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
