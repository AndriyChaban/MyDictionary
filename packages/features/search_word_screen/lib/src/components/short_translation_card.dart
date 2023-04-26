import 'package:flutter/material.dart';

class ShortTranslationCard extends StatelessWidget {
  const ShortTranslationCard(
      {Key? key,
      required this.onWordClick,
      required this.headword,
      required this.text,
      this.dictionaryName = ''})
      : super(key: key);
  final String headword;
  final String text;
  final String dictionaryName;
  final void Function(String) onWordClick;

  @override
  Widget build(BuildContext context) {
    final fullTextUpdated = text
        .replaceAll('[', '<')
        .replaceAll(']', '>')
        .replaceAll(r'\<', '[')
        .replaceAll(r'\>', ']');
    String? textExtract = RegExp(r'<trn>(.+)</trn>')
            .firstMatch(fullTextUpdated)
            ?.group(1)
            ?.replaceAll(RegExp(r'<.*?>'), '') ??
        fullTextUpdated.replaceAll(RegExp(r'<.*?>'), '');
    String headwordCleaned = headword.replaceAll(RegExp(r'\{.+?\}'), '');
    return ListTile(
        onTap: () => onWordClick(headword),
        title: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                headwordCleaned,
                maxLines: 3,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
              ),
              Text(dictionaryName),
            ],
          ),
        ),
        subtitle: Text(
          textExtract,
          maxLines: 3,
          style: TextStyle(
              height: 1.2,
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
        ));
  }
}
