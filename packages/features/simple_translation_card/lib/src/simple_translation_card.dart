import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:simple_translation_card/src/selectable_styled_translation_card.dart';

class SimpleTranslationCard extends StatelessWidget {
  const SimpleTranslationCard(
      {Key? key,
      // required this.headword,
      // this.meaning,
      // this.fullText,
      // this.examples,
      required this.card})
      : super(key: key);

  static const routeName = 'simple-translation-card';

  final WizzCardDM card;

  // final String headword;
  // final String? meaning;
  // final String? fullText;
  // final String? examples;

  @override
  Widget build(BuildContext context) {
    final headword = card.word;
    final meaning = card.meaning;
    final examples = card.examples;
    final fullText = card.fullText;
    String meaningText =
        meaning != null && meaning.isNotEmpty ? '<trn>$meaning</trn>' : '';
    String examplesText =
        examples != null && examples.isNotEmpty ? '<ex>$examples</ex>' : '';
    final text = '$meaningText\n$examplesText';
    print(text);
    final Widget body = fullText != null && fullText.isNotEmpty
        ? SelectableStyledTranslationCard(
            headword: headword, fullText: fullText)
        : SelectableStyledTranslationCard(
            headword: headword,
            fullText: text,
          );
    return Scaffold(
      appBar: AppBar(
        title: Text(headword),
      ),
      body: body,
    );
  }
}
