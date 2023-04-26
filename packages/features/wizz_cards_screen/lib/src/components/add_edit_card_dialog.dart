import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class AddEditWizzCardDialog extends StatefulWidget {
  final CardDM? cardFromDictionary;
  final WizzCardDM? cardForEditing;
  final WizzDeckDM deck;
  final Function(BuildContext, dynamic)? popCallback;
  final Function(BuildContext, WizzCardDM)? pushToSimpleTranslationCard;
  final Future<String?> Function(String) nameValidator;
  const AddEditWizzCardDialog(
      {Key? key,
      this.cardForEditing,
      this.cardFromDictionary,
      this.popCallback,
      required this.deck,
      required this.nameValidator,
      this.pushToSimpleTranslationCard})
      : super(key: key);

  @override
  State<AddEditWizzCardDialog> createState() => _AddEditWizzCardDialogState();
}

class _AddEditWizzCardDialogState extends State<AddEditWizzCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _wordTextController = TextEditingController();
  final _meaningTextController = TextEditingController();
  final _examplesTextController = TextEditingController();
  late String fromLanguage;
  late String toLanguage;
  late final bool isEdit = widget.cardForEditing != null;
  late final bool isFromDictionary = widget.cardFromDictionary != null;
  // late ShowFrequencyDM showFrequency;
  String? errorWordValidation;

  @override
  void initState() {
    super.initState();
    fromLanguage = widget.deck.fromLanguage;
    toLanguage = widget.deck.toLanguage;

    final wordText = isEdit
        ? widget.cardForEditing!.word
        : isFromDictionary
            ? widget.cardFromDictionary!.headword
            : '';
    String wordTextCleaned =
        wordText.replaceAll("{[']}", '').replaceAll("{[/']}", '');

    _wordTextController.text = wordTextCleaned;
    _wordTextController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _wordTextController.text.length,
    );

    _meaningTextController.text = isEdit
        ? widget.cardForEditing!.meaning
        : isFromDictionary
            ? _parseMeaning(widget.cardFromDictionary!.text
                .replaceAll('[', '<')
                .replaceAll(']', '>')
                .replaceAll(r'\<', '[')
                .replaceAll(r'\>', ']'))
            : '';

    _examplesTextController.text = isEdit
        ? widget.cardForEditing?.examples ?? ''
        : isFromDictionary
            ? _parseExamples(widget.cardFromDictionary!.text
                .replaceAll('[', '<')
                .replaceAll(']', '>')
                .replaceAll(r'\<', '[')
                .replaceAll(r'\>', ']'))
            : '';

    // showFrequency =
    //     isEdit ? widget.cardForEditing!.showFrequency! : ShowFrequencyDM.normal;
  }

  String _parseMeaning(String text) {
    final regExp = RegExp(r'<trn>(.*?)</trn>');
    String result = '';
    for (var match in regExp.allMatches(text)) {
      if (match.group(1) != null) result += '\n${match.group(1)!}';
      if (result.length > 50) break;
    }
    result = result.replaceAll(RegExp(r'<.*?>'), '');
    return result.trim();
  }

  String _parseExamples(String text) {
    final regExp = RegExp(r'<ex>(.*?)</ex>');
    String result = '';
    for (var match in regExp.allMatches(text)) {
      if (match.group(1) != null) result += '\n${match.group(1)!}';
      if (result.length > 50) break;
    }
    result = result.replaceAll(RegExp(r'<.*?>'), '');
    return result.trim();
  }

  @override
  void dispose() {
    _wordTextController.dispose();
    _meaningTextController.dispose();
    _examplesTextController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (isEdit && (widget.cardForEditing!.word == _wordTextController.text)) {
      errorWordValidation = null;
    } else {
      errorWordValidation =
          await widget.nameValidator(_wordTextController.text);
    }
    if (_formKey.currentState!.validate()) {
      final newCard = WizzCardDM(
          word: _wordTextController.text,
          meaning: _meaningTextController.text,
          examples: _examplesTextController.text,
          level: 0,
          fullText: isEdit
              ? widget.cardForEditing!.fullText
              : isFromDictionary
                  ? widget.cardFromDictionary!.text
                  : null);
      // if (widget.cardFromDictionary != null) {
      //   // widget.goToNamed(context, 'search-view');
      //     widget.popCallback!(context, newCard);
      // } else {
      if (widget.popCallback != null && mounted) {
        widget.popCallback!(context, newCard);
      }
      // }
    }
  }

  void _onCancel() {
    // FocusScope.of(context).unfocus();
    widget.popCallback!(context, null);
  }

  void _onOpenCard() {
    final card = WizzCardDM(
        word: widget.cardForEditing?.word ??
            widget.cardFromDictionary?.headword ??
            'None',
        meaning: widget.cardForEditing?.meaning ?? '',
        examples: widget.cardForEditing?.examples,
        fullText: widget.cardFromDictionary?.text ??
            widget.cardForEditing?.fullText ??
            '');
    widget.pushToSimpleTranslationCard!(context, card);
  }

  @override
  Widget build(BuildContext context) {
    assert(
        !(widget.cardFromDictionary != null && widget.cardForEditing != null),
        'widget.cardFromDictionary != null && widget.cardForEditing != null');
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
                  'Create New Card',
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Text(
              'Edit "${widget.cardForEditing!.word}" card',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.deck.fromLanguage.toCapital()),
                  const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                  Text(widget.deck.toLanguage.toCapital()),
                ],
              ),
              const SizedBox(height: 5),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //   const Text('Priority: '),
              //   Column(
              //     children: [
              //       Radio<ShowFrequencyDM>(
              //           value: ShowFrequencyDM.low,
              //           groupValue: showFrequency,
              //           onChanged: (val) {
              //             setState(() {
              //               showFrequency = val!;
              //             });
              //           }),
              //       const Text('Low'),
              //     ],
              //   ),
              //   Column(
              //     children: [
              //       Radio<ShowFrequencyDM>(
              //           value: ShowFrequencyDM.normal,
              //           groupValue: showFrequency,
              //           onChanged: (val) {
              //             setState(() {
              //               showFrequency = val!;
              //             });
              //           }),
              //       const Text('Normal'),
              //     ],
              //   ),
              //   Column(
              //     children: [
              //       Radio<ShowFrequencyDM>(
              //           value: ShowFrequencyDM.high,
              //           groupValue: showFrequency,
              //           onChanged: (val) {
              //             setState(() {
              //               showFrequency = val!;
              //             });
              //           }),
              //       const Text('High'),
              //     ],
              //   ),
              // ]),
              const SizedBox(height: 15),
              TextFormField(
                autofocus: false,
                controller: _wordTextController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  label: const Text('Word'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                validator: (name) {
                  return errorWordValidation;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _meaningTextController,
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  label: const Text('Meaning'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                validator: (m) {
                  if (m == null || m.trim().isEmpty) {
                    return 'Meaning must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _examplesTextController,
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  label: const Text('Examples'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        if (((widget.cardFromDictionary != null &&
                widget.cardFromDictionary!.text.isNotEmpty) ||
            (widget.cardForEditing != null)))
          IconButton(
            onPressed: _onOpenCard,
            icon: const Icon(Icons.translate),
          ),
        const SizedBox(width: 30),
        TextButton(
          onPressed: _onCancel,
          child: const Text(
            'CANCEL',
            // style: TextStyle(color: Colors.black54),
          ),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child: !isEdit ? const Text('ADD') : const Text('EDIT'),
        ),
      ],
    );
  }
}
