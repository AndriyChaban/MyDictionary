import 'package:components/src/styled_tappable_text.dart';
import 'package:flutter/material.dart';

class StyledTranslationCard extends StatelessWidget {
  const StyledTranslationCard(
      {Key? key,
      this.isShort = false,
      required this.onClick,
      required this.headword,
      required this.text,
      this.dictionaryName = ''})
      : super(key: key);
  final String headword;
  final String text;
  final String dictionaryName;
  final bool isShort;
  final void Function(String)? onClick;

  @override
  Widget build(BuildContext context) {
    final extraText = text
        .replaceAll('<m1>', '\t<m1>')
        .replaceAll('<m2>', '\t\t<m2>')
        .replaceAll('<m3>', '\t\t\t<m3>');
    final textExtract = RegExp(r'<trn>(.+)</trn>')
        .firstMatch(extraText)
        ?.group(1)
        ?.replaceAll(RegExp(r'<.*?>'), '');
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
    return Padding(
      padding: EdgeInsets.all(isShort ? 0 : 8.0),
      child: ListTile(
          onTap: isShort ? () => onClick!(headword) : null,
          // onTap: () => print(card.headword),
          title: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  headword,
                  maxLines: 3,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(dictionaryName),
              ],
            ),
          ),
          subtitle: isShort
              ? Text(
                  textExtract ?? text,
                  maxLines: 3,
                  style: const TextStyle(height: 1.2),
                )
              : StyledTappableText(text: text, onWordTap: onClick!)),
    );
  }
}
