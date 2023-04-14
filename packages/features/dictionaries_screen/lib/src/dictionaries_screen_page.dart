import 'package:dictionaries_screen/src/components/dictionaries_appbar.dart';
import 'package:dictionaries_screen/src/dictionaries_screen_cubit.dart';
import 'package:dictionary_provider/dictionary_provider.dart';
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
      required this.scaffoldKey})
      : super(key: key);
  static const routeName = 'dictionaries-screen';
  final DictionaryProvider dictionaryProvider;
  final UserRepository userRepository;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<DictionariesScreen> createState() => _DictionariesScreenState();
}

class _DictionariesScreenState extends State<DictionariesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DictionaryScreenCubit>(
        create: (context) => DictionaryScreenCubit(
            userRepository: widget.userRepository,
            dictionaryProvider: widget.dictionaryProvider)
          ..initialLoad(),
        child: Scaffold(
          appBar: DictionariesAppBar(scaffoldKey: widget.scaffoldKey),
          body: BlocConsumer<DictionaryScreenCubit, DictionariesScreenState>(
            listener: (context, state) {
              if (state.message != null) {
                buildInfoSnackBar(context, state.message!);
              }
            },
            builder: (context, state) {
              final list = state.dictionaryList;
              return Stack(
                children: [
                  ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (context, index) => DictionaryTile(
                      key: ValueKey(list[index].name),
                      dictionary: list[index],
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const DividerCommon(),
                  ),
                  if (state.isLoading) const CenteredLoadingProgressIndicator()
                ],
              );
            },
          ),
        ));
  }
}

class DictionaryTile extends StatefulWidget {
  const DictionaryTile({Key? key, required this.dictionary}) : super(key: key);

  final DictionaryDM dictionary;

  @override
  State<DictionaryTile> createState() => _DictionaryTileState();
}

class _DictionaryTileState extends State<DictionaryTile> {
  // late bool _isActive = widget.dictionary.active;

  void _onChangeActive(status) {
    context
        .read<DictionaryScreenCubit>()
        .dictionaryStatusChanged(widget.dictionary, status);
    // setState(() {
    //   _isActive = val;
    // });
  }

  void _onPressDeleteDictionary() {
    context.read<DictionaryScreenCubit>().deleteDictionary(widget.dictionary);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // isThreeLine: true,
      title: Text(widget.dictionary.name),
      // horizontalTitleGap: 20,
      subtitle: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.dictionary.indexLanguage.toCapital()),
          const Icon(Icons.arrow_forward),
          Text(widget.dictionary.contentLanguage.toCapital())
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            onChanged: _onChangeActive,
            value: widget.dictionary.active,
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.black54,
            ),
            onPressed: _onPressDeleteDictionary,
          )
        ],
      ),
    );
  }
}
