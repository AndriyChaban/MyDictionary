import 'package:components/components.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main_screen/src/main_screen_bloc.dart';

import '../main_screen_state.dart';

class DictionariesView extends StatefulWidget {
  const DictionariesView({Key? key}) : super(key: key);
  static const routeName = 'dictionaries-view';

  @override
  State<DictionariesView> createState() => _DictionariesViewState();
}

class _DictionariesViewState extends State<DictionariesView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        final list =
            context.read<MainScreenBloc>().listOfAllMatchingDictionaries;
        return ListView.separated(
          itemCount: list.length,
          itemBuilder: (context, index) =>
              DictionaryTile(dictionary: list[index]),
          separatorBuilder: (BuildContext context, int index) =>
              const DividerCommon(),
        );
      },
    );
  }
}

class DictionaryTile extends StatefulWidget {
  const DictionaryTile({Key? key, required this.dictionary}) : super(key: key);

  final DictionaryDM dictionary;

  @override
  State<DictionaryTile> createState() => _DictionaryTileState();
}

class _DictionaryTileState extends State<DictionaryTile> {
  late bool _isActive = widget.dictionary.active;

  @override
  Widget build(BuildContext context) {
    print(widget.dictionary);
    return ListTile(
      key: ValueKey(widget.dictionary.name),
      leading: Text(widget.dictionary.name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.dictionary.indexLanguage),
          Icon(Icons.arrow_forward),
          Text(widget.dictionary.contentLanguage)
        ],
      ),
      trailing: Switch(
        onChanged: (val) {
          setState(() {
            _isActive = val;
          });
        },
        value: _isActive,
      ),
    );
  }
}
