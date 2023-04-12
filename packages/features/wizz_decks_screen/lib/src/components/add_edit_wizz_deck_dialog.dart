import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class AddEditWizzDeckDialog extends StatefulWidget {
  final WizzDeckDM? deck;
  final DictionaryDM? dictionary;
  final Function(BuildContext, dynamic)? popCallback;
  final Future<String?> Function(String, String, String) nameValidator;
  const AddEditWizzDeckDialog(
      {Key? key,
      this.deck,
      this.popCallback,
      this.dictionary,
      required this.nameValidator})
      : super(key: key);

  @override
  State<AddEditWizzDeckDialog> createState() => _AddEditWizzDeckDialogState();
}

class _AddEditWizzDeckDialogState extends State<AddEditWizzDeckDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late String fromLanguage;
  late String toLanguage;
  late final bool isEdit = widget.deck != null;
  late final bool isFromDictionary = widget.dictionary != null;
  String? errorNameValidation;

  @override
  void initState() {
    super.initState();
    fromLanguage = isEdit
        ? widget.deck!.fromLanguage
        : isFromDictionary
            ? widget.dictionary!.indexLanguage
            : klistIfLanguages.first;
    toLanguage = isEdit
        ? widget.deck!.toLanguage
        : isFromDictionary
            ? widget.dictionary!.contentLanguage
            : klistIfLanguages.first;
    _textController.text = isEdit ? widget.deck!.name : '';
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (isEdit && (widget.deck?.name == _textController.text)) {
      errorNameValidation = null;
    } else {
      errorNameValidation = await widget.nameValidator(
          _textController.text, fromLanguage, toLanguage);
    }
    if (_formKey.currentState!.validate()) {
      final newDeck = WizzDeckDM(
          name: _textController.text,
          fromLanguage: fromLanguage,
          toLanguage: toLanguage,
          cards: isEdit ? widget.deck!.cards : []);
      if (widget.popCallback != null && mounted) {
        widget.popCallback!(context, newDeck);
      }
    }
  }

  void _onCancel() {
    if (widget.popCallback != null) {
      FocusScope.of(context).unfocus();
      widget.popCallback!(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<WizzDeckScreenCubit>();
    assert(!(widget.deck != null && widget.dictionary != null),
        'deck and dictionary cannot be both non null');
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      title: !isEdit
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Create New Deck',
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Text(
              'Edit ${widget.deck!.name} deck',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isEdit && widget.deck!.cards.isNotEmpty || isFromDictionary
                    ? Text(fromLanguage.toCapital())
                    : DropdownButton<String>(
                        value: fromLanguage,
                        borderRadius: BorderRadius.circular(5),
                        items: [
                          ...klistIfLanguages
                              .map((l) => DropdownMenuItem(
                                    value: l,
                                    child: Text(l.toCapital()),
                                  ))
                              .toList()
                        ],
                        onChanged: (val) {
                          setState(() {
                            fromLanguage = val!;
                          });
                        }),
                const Icon(Icons.navigate_next),
                isEdit && widget.deck!.cards.isNotEmpty || isFromDictionary
                    ? Text(toLanguage.toCapital())
                    : DropdownButton<String>(
                        value: toLanguage,
                        borderRadius: BorderRadius.circular(5),
                        items: [
                          ...klistIfLanguages
                              .map((l) => DropdownMenuItem(
                                    value: l,
                                    child: Text(l.toCapital()),
                                  ))
                              .toList()
                        ],
                        onChanged: (val) {
                          setState(() {
                            toLanguage = val!;
                          });
                        }),
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              autofocus: false,
              controller: _textController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                label: const Text('Name'),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              validator: (name) {
                return errorNameValidation;
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onCancel,
          child: const Text(
            'CANCEL',
            // style: TextStyle(color: Colors.black54),
          ),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child:
              widget.deck == null ? const Text('CREATE') : const Text('EDIT'),
        ),
      ],
    );
  }
}
