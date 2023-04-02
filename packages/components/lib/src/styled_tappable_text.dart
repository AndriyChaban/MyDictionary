import 'dart:ui';

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';

class StyledTappableText extends StatefulWidget {
  StyledTappableText({Key? key, required this.text, required this.onWordTap})
      : super(key: key);
  final String text;
  final void Function(String) onWordTap;

  @override
  State<StyledTappableText> createState() => _StyledTappableTextState();
}

class _StyledTappableTextState extends State<StyledTappableText> {
  int selectedIndex = -1;

  final Map<String, Color> colorMap = {
    'c': Colors.green,
    'ex': Colors.grey,
    't': const Color(0xFF80211C),
    "'": Colors.red
  };

  List<InlineSpan> _createChildren(String text) {
    final lines = text.split('\n');
    final nodes = <TextNode>[];
    for (var line in lines) {
      //cycle each line, check if starts with <m> -> add spaces, remove <*>,
      line = line.replaceAll(RegExp(r'<.?\*>'), '');
      String spaces = '';
      if (line.startsWith('\t<m')) {
        final indentationString = RegExp(r'<m(\d)>').firstMatch(line)?.group(1);
        int indentation;
        if (indentationString != null) {
          indentation = int.parse(indentationString);
          spaces = ' ' * indentation;
          if (spaces.isNotEmpty) nodes.add(TextNode()..text = spaces);
        }
      }
      line = line.replaceAll(RegExp(r'<.?m\d?>'), '');
      final textPatchRegExp = RegExp(
        r'(?<=[\t>])([^<>]+)(?![^<])',
      );
      final textPatchMatches = textPatchRegExp.allMatches(line);
      for (var textMatch in textPatchMatches) {
        bool betweenRef =
            isBetween(tag: 'ref', textMatch: textMatch, fullString: line);
        bool betweenTrn =
            isBetween(tag: 'trn', textMatch: textMatch, fullString: line);
        bool betweenC =
            isBetween(tag: 'c', textMatch: textMatch, fullString: line);
        bool betweenP =
            isBetween(tag: 'p', textMatch: textMatch, fullString: line);
        bool betweenU =
            isBetween(tag: 'u', textMatch: textMatch, fullString: line);
        bool betweenB =
            isBetween(tag: 'b', textMatch: textMatch, fullString: line);
        bool betweenI =
            isBetween(tag: 'i', textMatch: textMatch, fullString: line);
        bool betweenEx =
            isBetween(tag: 'ex', textMatch: textMatch, fullString: line);
        bool betweenLang =
            isBetween(tag: 'lang', textMatch: textMatch, fullString: line);
        bool betweenT =
            isBetween(tag: 't', textMatch: textMatch, fullString: line);
        bool betweenGap =
            isBetween(tag: "'", textMatch: textMatch, fullString: line);
        bool betweenS =
            isBetween(tag: "s", textMatch: textMatch, fullString: line);
        if (betweenRef) {
          final node = TextNode()
            ..isRef = true
            ..color = Colors.blue
            ..text = textMatch.group(1)!
            ..onTap = () {
              print(textMatch.group(1)!);
              setState(() {
                selectedIndex = -1;
                widget.onWordTap(textMatch.group(1)!);
              });
            };
          nodes.add(node);
        } else {
          final words = textMatch.group(1)!.split(RegExp(r'\s'));
          for (var word in words) {
            final wordNode = TextNode()
              ..isWidget = betweenS
              ..text = word
              ..color = betweenC || betweenP
                  ? colorMap['c']!
                  : betweenT
                      ? colorMap['t']!
                      : betweenGap
                          ? colorMap["'"]!
                          : betweenEx
                              ? Colors.grey
                              : Theme.of(context).textTheme.bodyMedium!.color!
              ..isUnderline = betweenU
              ..isBold = betweenB
              ..isItalic = betweenI
              ..isSelectable = (betweenTrn || betweenEx || betweenLang) &&
                  !betweenGap &&
                  !betweenP;
            if (word.startsWith(')') ||
                RegExp(r'^[,.;:!?]').firstMatch(word)?.start == 0) {
              nodes.last = wordNode;
            } else {
              nodes.add(wordNode);
            }
            if (!word.endsWith('(')) nodes.add(TextNode()..text = ' ');
          }
        }
      }
      nodes.add(TextNode()..text = '\n');
    }
    return nodes.map((n) {
      if (n.isWidget) {
        return n.span;
      } else if (n.isSelectable) {
        return (n
              ..isSelected = nodes.indexOf(n) == selectedIndex
              ..onTap = () {
                print(n.text);
                setState(() {
                  selectedIndex = nodes.indexOf(n);
                });
                print(selectedIndex);
              })
            .span;
      } else {
        return n.span;
      }
    }).toList();
  }

  bool isBetween(
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: RichText(
        text: TextSpan(
          children: _createChildren(widget.text),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class TextNode {
  String text = '';
  bool isWidget = false;
  bool isSelectable = false;
  bool isRef = false;
  bool isItalic = false;
  bool isBold = false;
  Color color = Colors.black;
  bool isUnderline = false;
  bool isSelected = false;
  Function()? onTap;

  InlineSpan get span {
    if (isWidget) return WidgetSpan(child: Icon(Icons.volume_up_rounded));
    return TextSpan(
        text: text,
        style: TextStyle(
          backgroundColor: isSelected ? Colors.yellow : Colors.transparent,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          decoration:
              isUnderline ? TextDecoration.underline : TextDecoration.none,
          color: color,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = onTap ??
              () {
                // print(text);
              });
  }
}
