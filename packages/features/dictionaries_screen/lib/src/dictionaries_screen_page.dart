import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dictionaries_screen/src/components/dictionaries_appbar.dart';
import 'package:dictionaries_screen/src/dictionaries_screen_cubit.dart';
import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:user_repository/user_repository.dart';

import 'components/centered_info_dialog.dart';

class DictionariesScreen extends StatefulWidget {
  const DictionariesScreen(
      {Key? key,
      required this.dictionaryProvider,
      required this.userRepository,
      required this.scaffoldKey,
      required this.pop})
      : super(key: key);
  static const routeName = 'dictionaries-screen';
  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(BuildContext, dynamic) pop;

  @override
  State<DictionariesScreen> createState() => _DictionariesScreenState();
}

class _DictionariesScreenState extends State<DictionariesScreen> {
  void _onPressedAddDictionary(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: 'Pick *.dsl file',
    );
    if (result != null && mounted) {
      context
          .read<DictionaryScreenCubit>()
          .addDictionary(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DictionaryScreenCubit>(
        create: (context) => DictionaryScreenCubit(
            userRepository: widget.userRepository,
            dictionaryProvider: widget.dictionaryProvider)
          ..initialLoad(),
        child: BlocConsumer<DictionaryScreenCubit, DictionariesScreenState>(
          listener: (context, state) {
            if (state.message != null && !state.isLoading) {
              buildInfoSnackBar(context, state.message!);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  appBar: DictionariesAppBar(scaffoldKey: widget.scaffoldKey),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => _onPressedAddDictionary(context),
                    child: const Icon(Icons.add),
                  ),
                  body: Builder(
                    builder: (context) {
                      final list = state.dictionaryList;
                      return state.dictionaryList.isNotEmpty
                          ? ListView.separated(
                              itemCount: list.length + 1,
                              itemBuilder: (context, index) {
                                if (index >= list.length) {
                                  return const SizedBox(height: 50);
                                } else {
                                  return DictionaryTile(
                                      key: ValueKey(list[index].name),
                                      dictionary: list[index],
                                      pop: widget.pop);
                                }
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const DividerCommon(),
                            )
                          : const Center(
                              child: Text('No dictionaries'),
                            );
                    },
                  ),
                ),
                if (state.isLoading)
                  CenteredInfoDialog(message: state.message ?? '')
              ],
            );
          },
        ));
  }
}

class DictionaryTile extends StatefulWidget {
  const DictionaryTile({Key? key, required this.dictionary, required this.pop})
      : super(key: key);

  final DictionaryDM dictionary;
  final Function(BuildContext, dynamic) pop;

  @override
  State<DictionaryTile> createState() => _DictionaryTileState();
}

class _DictionaryTileState extends State<DictionaryTile>
    with SingleTickerProviderStateMixin {
  late final _iconController = AnimationController(vsync: this);

  void _onChangeActive(BuildContext context, bool status) {
    context
        .read<DictionaryScreenCubit>()
        .dictionaryStatusChanged(widget.dictionary, status);
  }

  void _onPressDeleteDictionary(BuildContext context) async {
    _iconController.repeat(period: const Duration(milliseconds: 1500));
    final response = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmCancelDialog(
            title: 'Delete ${widget.dictionary.name} dictionary?',
            onCancel: () => widget.pop(context, false),
            onConfirm: () => widget.pop(context, true));
      },
    );
    if (response == true && mounted) {
      context.read<DictionaryScreenCubit>().deleteDictionary(widget.dictionary);
    } else {
      _iconController.reset();
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        // isThreeLine: true,
        title: Text(
          widget.dictionary.name,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
        ),
        // horizontalTitleGap: 20,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.dictionary.indexLanguage.toCapital()),
                const Icon(Icons.arrow_forward),
                Text(widget.dictionary.contentLanguage.toCapital())
              ],
            ),
            Text(
              '${widget.dictionary.entriesNumber} entries',
              textAlign: TextAlign.left,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedToggleSwitch<bool>.dual(
              current: widget.dictionary.active,
              first: false,
              second: true,
              dif: 0.0,
              borderColor: Colors.transparent,
              borderWidth: 5.0,
              height: 55,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1.5),
                ),
              ],
              onChanged: (val) => _onChangeActive(context, val),
              colorBuilder: (b) => b ? Colors.green : Colors.red,
              iconBuilder: (value) =>
                  value ? const Icon(Icons.mood) : const Icon(Icons.mood_bad),
              textBuilder: (value) => value
                  ? const Center(child: Text('ON'))
                  : const Center(child: Text('OFF')),
            ),
            GestureDetector(
              onTap: () => _onPressDeleteDictionary(context),
              child: Lottie.asset(
                'assets/icons/delete.json',
                controller: _iconController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
