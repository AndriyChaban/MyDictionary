import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:translation_screen/src/components/styled_tappable_text.dart';

class StyledTranslationCard extends StatelessWidget {
  const StyledTranslationCard(
      {Key? key,
      this.isShort = false,
      required this.onWordClick,
      required this.headword,
      required this.text,
      required this.index,
      this.dictionaryName = '',
      required this.onAddToWizzDeck})
      : super(key: key);
  final String headword;
  final String text;
  final String dictionaryName;
  final bool isShort;
  final int index;
  final void Function(String) onWordClick;
  final VoidCallback onAddToWizzDeck;

  @override
  Widget build(BuildContext context) {
    // final extraText = text
    //     .replaceAll('<m1>', '\t<m1>')
    //     .replaceAll('<m2>', '\t\t<m2>')
    //     .replaceAll('<m3>', '\t\t\t<m3>');
    // final textExtract = RegExp(r'<trn>(.+)</trn>')
    //     .firstMatch(extraText)
    //     ?.group(1)
    //     ?.replaceAll(RegExp(r'<.*?>'), '');
    // Map<String, StyledTextTagBase> tags = {
    //   'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
    //   'i': StyledTextTag(style: TextStyle(fontStyle: FontStyle.italic)),
    //   'u':
    //       StyledTextTag(style: TextStyle(decoration: TextDecoration.underline)),
    //   'c': StyledTextTag(style: TextStyle(color: Colors.green)),
    //   'trn': StyledTextTag(style: TextStyle(color: Colors.black)),
    //   // 'p': StyledTextTag(style: TextStyle(color: Colors.green)),
    //   "'": StyledTextTag(style: TextStyle(color: Colors.red)),
    //   'ex': StyledTextTag(style: TextStyle(color: Colors.grey)),
    //   't': StyledTextTag(style: TextStyle(color: Color(0xFF80211C))),
    //   's': StyledTextIconTag(Icons.volume_up_rounded),
    // };
    final updatedText = text
        .replaceAll('[', '<')
        .replaceAll(']', '>')
        .replaceAll(r'\<', '[')
        .replaceAll(r'\>', ']');
    String headwordCleaned = headword.replaceAll("{[']}", '');
    return Padding(
      padding: EdgeInsets.all(isShort ? 0 : 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(child: DividerCommon()),
              IconButton(
                  onPressed: onAddToWizzDeck,
                  icon: const Icon(Icons.add_reaction_outlined)),
              Text(dictionaryName, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          ListTile(
              onTap: isShort ? () => onWordClick(headword) : null,
              title: Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 6, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      headwordCleaned,
                      maxLines: 3,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              subtitle: isShort
                  ? Text(
                      updatedText,
                      maxLines: 3,
                      style: const TextStyle(height: 1.2),
                    )
                  : StyledTappableText(
                      text: updatedText,
                      onWordTap: onWordClick,
                      index: index,
                    )),
        ],
      ),
    );
  }
}
