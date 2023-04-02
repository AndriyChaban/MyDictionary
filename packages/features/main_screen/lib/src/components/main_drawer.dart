import 'package:domain_models/domain_models.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/main_screen.dart';
import 'package:main_screen/src/main_screen_bloc.dart';
import 'package:main_screen/src/main_screen_event.dart';
// import 'package:permission_handler/permission_handler.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({Key? key, required this.goToView, required this.onAddDictionary})
      : super(key: key);

  final void Function(BuildContext, String) goToView;
  final Function() onAddDictionary;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  void _onAddDictionary() async {
    // context.read<MainScreenBloc>().add(MainScreenEventFakeLoading());
    // FilePickerResult? result = await FilePicker.platform.pickFiles();
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
    // await Permission.storage.request();
    if (mounted) {
      // if (status.isGranted) {
      // if (result != null) {
      // Future.delayed(Duration(seconds: 1), () {
      widget.onAddDictionary();
      // context.read<MainScreenBloc>().add(
      //     const MainScreenEventAddDictionary('assets/UniversalEnUk.dsl'));
      // });
      // context.read<MainScreenBloc>().add(const MainScreenEventFakeLoading());
      // .add(MainScreenEventAddDictionary(result.files.single.path!));
      // }
      // }
    }
  }

  Future<void> _onDeleteDict(
      BuildContext context, DictionaryDM dictionaryName) async {
    context
        .read<MainScreenBloc>()
        .add(MainScreenEventDeleteDictionary(dictionaryName));
  }

  void _onInstalledDictionariesTap(BuildContext context) {
    Navigator.pop(context);
    widget.goToView(context, DictionariesView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

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
                    onPressed: () => _onAddDictionary(),
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
                  Divider(),
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
