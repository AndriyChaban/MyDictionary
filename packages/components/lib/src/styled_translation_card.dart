import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class StyledTranslationCard extends StatelessWidget {
  const StyledTranslationCard(
      {Key? key,
      this.isShort = false,
      required this.onClick,
      required this.headword,
      required this.text})
      : super(key: key);
  final String headword;
  final String text;
  final bool isShort;
  final Function(String)? onClick;

  @override
  Widget build(BuildContext context) {
    // bool test = false;
    final extraText = text
        .replaceAll('<m1>', '\t<m1>')
        .replaceAll('<m2>', '\t\t<m2>')
        .replaceAll('<m3>', '\t\t\t<m3>');
    final textExtract =
        RegExp(r'<trn>(.+)</trn>').firstMatch(extraText)?.group(1);
    Map<String, StyledTextTagBase> tags = {
      'b': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
      'i': StyledTextTag(style: TextStyle(fontStyle: FontStyle.italic)),
      'u':
          StyledTextTag(style: TextStyle(decoration: TextDecoration.underline)),
      'c': StyledTextTag(style: TextStyle(color: Colors.green)),
      'trn': StyledTextTag(style: TextStyle(color: Colors.black)),
      'p': StyledTextTag(style: TextStyle(color: Colors.green)),
      "'": StyledTextTag(style: TextStyle(color: Colors.red)),
      'ex': StyledTextTag(style: TextStyle(color: Colors.grey)),
      't': StyledTextTag(style: TextStyle(color: Color(0xFF80211C))),
      's': StyledTextIconTag(Icons.volume_up_rounded),
    };
    return ListTile(
      onTap: isShort ? () => onClick!(headword) : null,
      // onTap: () => print(card.headword),
      title: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6, bottom: 10),
        child: Text(
          headword,
          maxLines: 3,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: isShort
          ? StyledText(
              text: textExtract ?? text,
              style: const TextStyle(height: 1.2),
              maxLines: 3,
              tags: tags,
            )
          : StyledText.selectable(
              onTap: () {},
              text: isShort ? textExtract ?? 'null' : extraText,
              style: const TextStyle(height: 1.2),
              // maxLines: 3,
              // scrollPhysics: const NeverScrollableScrollPhysics(),
              newLineAsBreaks: true,
              tags: tags,
            ),
    );
  }
}
