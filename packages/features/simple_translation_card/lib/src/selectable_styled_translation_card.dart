import 'package:flutter/material.dart';

class SelectableStyledTranslationCard extends StatelessWidget {
  const SelectableStyledTranslationCard(
      {Key? key, required this.headword, required this.fullText})
      : super(key: key);
  final String headword;
  final String fullText;

  @override
  Widget build(BuildContext context) {
    // String headwordCleaned =
    //     headword.replaceAll("{[']}", '').replaceAll("{[/']}", '');
    // print(fullText);
    final fullTextUpdated = fullText
        .replaceAll('[', '<')
        .replaceAll(']', '>')
        .replaceAll(r'\<', '[')
        .replaceAll(r'\>', ']');
    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DividerCommon(),
          // SizedBox(height: 10),
          SingleChildScrollView(
            child: Column(
              children: [
                // Text(
                //   headwordCleaned,
                //   maxLines: 3,
                //   style: const TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                SelectableStyledText(fullText: fullTextUpdated)
                // StyledTappableText(
                // text: text,
                // onWordTap: onWordClick,
                // index: index,
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectableStyledText extends StatelessWidget {
  const SelectableStyledText({Key? key, required this.fullText})
      : super(key: key);
  final String fullText;

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
        TextSpan(children: _createChildren(context, fullText)));
  }
}

bool _isBetween(
    {required String tag,
    required RegExpMatch textMatch,
    required String fullString}) {
  final regExp = RegExp('<$tag.*?>(.+?)</$tag>');
  final tagMatches = regExp.allMatches(fullString);
  for (var match in tagMatches) {
    if (match.start < textMatch.start && match.end > textMatch.end) {
      return true;
    }
  }
  return false;
}

final Map<String, Color> colorMap = {
  'c': Colors.green,
  'ex': Colors.grey,
  't': const Color(0xFF80211C),
  "'": Colors.red
};

List<InlineSpan> _createChildren(BuildContext context, String text) {
  // print(text);
  final lines = text.split('\n');
  final spans = <InlineSpan>[];
  for (var line in lines) {
    /// cycle each line, check if starts with <m> -> add spaces, remove <*>, <m>
    line = line.replaceAll(RegExp(r'<.?\*>'), '');
    String spaces = '';
    if (line.startsWith('\t<m')) {
      final indentationString = RegExp(r'<m(\d)>').firstMatch(line)?.group(1);
      int indentation;
      if (indentationString != null) {
        indentation = int.parse(indentationString);
        spaces = ' ' * indentation;
        if (spaces.isNotEmpty) spans.add(TextSpan(text: spaces));
      }
    }
    line = line.replaceAll(RegExp(r'<.?m\d?>'), '');

    /// get text patches
    final textPatchRegExp = RegExp(
      // r'(?<=[\t>])([^<>]+)(?![^<])',
      r'([^<>]+)(?![^<])',
    );
    final textPatchMatches = textPatchRegExp.allMatches(line);

    /// check each patch on tags
    for (var textMatch in textPatchMatches) {
      bool betweenRef =
          _isBetween(tag: 'ref', textMatch: textMatch, fullString: line);
      bool betweenTrn =
          _isBetween(tag: 'trn', textMatch: textMatch, fullString: line);
      bool betweenC =
          _isBetween(tag: 'c', textMatch: textMatch, fullString: line);
      bool betweenP =
          _isBetween(tag: 'p', textMatch: textMatch, fullString: line);
      bool betweenU =
          _isBetween(tag: 'u', textMatch: textMatch, fullString: line);
      bool betweenB =
          _isBetween(tag: 'b', textMatch: textMatch, fullString: line);
      bool betweenI =
          _isBetween(tag: 'i', textMatch: textMatch, fullString: line);
      bool betweenEx =
          _isBetween(tag: 'ex', textMatch: textMatch, fullString: line);
      bool betweenLang =
          _isBetween(tag: 'lang', textMatch: textMatch, fullString: line);
      bool betweenT =
          _isBetween(tag: 't', textMatch: textMatch, fullString: line);
      bool betweenGap =
          _isBetween(tag: "'", textMatch: textMatch, fullString: line);
      bool betweenS =
          _isBetween(tag: "s", textMatch: textMatch, fullString: line);
      // print(textMatch.group(1)!);
      if (betweenS) {
        spans.add(WidgetSpan(
            child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.volume_up_sharp),
        )));
      } else if (!betweenRef) {
        final words = textMatch.group(1)!.split(RegExp(r'\s'));
        for (var word in words) {
          if (word.isEmpty) continue;
          final style = TextStyle(
              height: 0.7,
              fontStyle: betweenI ? FontStyle.italic : FontStyle.normal,
              fontWeight: betweenB ? FontWeight.bold : FontWeight.normal,
              decoration:
                  betweenU ? TextDecoration.underline : TextDecoration.none,
              color: betweenC || betweenP
                  ? colorMap['c']!
                  : betweenT
                      ? colorMap['t']!
                      : betweenGap
                          ? colorMap["'"]!
                          : betweenEx
                              ? Colors.grey
                              : Theme.of(context).textTheme.bodyMedium!.color!);
          // final wordSpan = TextSpan(text: word, style: style);
          //
          // final wordNode = TextNode()
          //   ..isSoundWidget = betweenS
          //   ..text = word
          //   ..color = betweenC || betweenP
          //       ? colorMap['c']!
          //       : betweenT
          //           ? colorMap['t']!
          //           : betweenGap
          //               ? colorMap["'"]!
          //               : betweenEx
          //                   ? Colors.grey
          //                   : Theme.of(context).textTheme.bodyMedium!.color!
          //   ..isUnderline = betweenU
          //   ..isBold = betweenB
          //   ..isItalic = betweenI
          //   ..isSelectable = (betweenTrn || betweenEx || betweenLang) &&
          //       !betweenGap &&
          //       !betweenP;
          if (word.startsWith(')') && spans.isNotEmpty) {
            spans.last = TextSpan(
                text: spans.last
                    .toPlainText()
                    .substring(0, spans.last.toPlainText().length - 1));
          }
          if (RegExp(r'[,.;:!?]').firstMatch(word)?.end == word.length) {
            spans.add(TextSpan(
                text: word.substring(0, word.length - 1), style: style));
            spans.add(
                TextSpan(text: word.substring(word.length - 1), style: style));
          } else {
            spans.add(TextSpan(text: word, style: style));
          }
          if (!word.endsWith('(')) spans.add(const TextSpan(text: ' '));
        }
      }
    }
    spans.add(TextSpan(text: '\n'));
  }
  return spans;
}
