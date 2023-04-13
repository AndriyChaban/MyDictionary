import 'package:flutter/material.dart';
import 'package:simple_translation_card/src/selectable_styled_translation_card.dart';

class SimpleTranslationCard extends StatelessWidget {
  const SimpleTranslationCard(
      {Key? key,
      required this.headword,
      this.meaning,
      this.fullText,
      this.examples})
      : super(key: key);

  static const routeName = 'simple-translation-card';

  final String headword;
  final String? meaning;
  final String? fullText;
  final String? examples;

  @override
  Widget build(BuildContext context) {
    String meaningText = meaning != null ? '<trn>$meaning</trn>' : '';
    String examplesText = examples != null ? '<ex>$examples</ex>' : '';
    final text = '$meaningText\n$examplesText';
    print(text);
    final Widget body = fullText != null && fullText!.isNotEmpty
        ? SelectableStyledTranslationCard(
            headword: headword, fullText: fullText!)
        : SelectableStyledTranslationCard(
            headword: headword,
            fullText: text,
          );
    return Scaffold(
      appBar: AppBar(),
      body: body,
    );
  }
}
