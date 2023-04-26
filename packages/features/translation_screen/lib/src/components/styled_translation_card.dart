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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              Expanded(
                  child: DividerCommon(
                color: isDark ? kAppBarColorDarkMode : kAppBarColorLightMode,
              )),
              IconButton(
                  onPressed: onAddToWizzDeck,
                  icon: const Icon(Icons.add_reaction_outlined)),
              Text(dictionaryName,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          Theme.of(context).textTheme.bodyLarge!.fontSize)),
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
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
