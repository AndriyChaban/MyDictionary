import 'package:dictionaries_screen/src/components/dictionaries_appbar.dart';
import 'package:dictionaries_screen/src/dictionaries_screen_cubit.dart';
import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

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
            if (state.message != null) {
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
                if (state.isLoading) const CenteredLoadingProgressIndicator()
              ],
            );
          },
        ));
  }
}

class DictionaryTile extends StatelessWidget {
  const DictionaryTile({Key? key, required this.dictionary, required this.pop})
      : super(key: key);

  final DictionaryDM dictionary;
  final Function(BuildContext, dynamic) pop;

  // late bool _isActive = widget.dictionary.active;
  void _onChangeActive(BuildContext context, bool status) {
    context
        .read<DictionaryScreenCubit>()
        .dictionaryStatusChanged(dictionary, status);
    // setState(() {
    //   _isActive = val;
    // });
  }

  void _onPressDeleteDictionary(BuildContext context) async {
    final response = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmCancelDialog(
            title: 'Delete ${dictionary.name} dictionary?',
            onCancel: () => pop(context, false),
            onConfirm: () => pop(context, true));
      },
    );
    if (response == true) {
      context.read<DictionaryScreenCubit>().deleteDictionary(dictionary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: ListTile(
        // isThreeLine: true,
        title: Text(dictionary.name),
        // horizontalTitleGap: 20,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(dictionary.indexLanguage.toCapital()),
                const Icon(Icons.arrow_forward),
                Text(dictionary.contentLanguage.toCapital())
              ],
            ),
            Text(
              '${dictionary.cards.length} entries',
              textAlign: TextAlign.left,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              onChanged: (val) => _onChangeActive(context, val),
              value: dictionary.active,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.black54,
              ),
              onPressed: () => _onPressDeleteDictionary(context),
            )
          ],
        ),
      ),
    );
  }
}
