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
        if (betweenRef) {
          final node = TextNode()
            ..isRef = true
            ..color = Colors.blue
            ..text = textMatch.group(1)!
            ..onTap = () {
              // print(textMatch.group(1)!);
              setState(() {
                selectedIndex = -1;
                widget.onWordTap(textMatch.group(1)!);
              });
            };
          nodes.add(node);
        } else {
          final words = textMatch.group(1)!.split(RegExp(r'\s'));
          for (var word in words) {
            if (word.isEmpty) continue;
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
            if (word.startsWith(')') && nodes.isNotEmpty) {
              nodes.last.text =
                  nodes.last.text.substring(0, nodes.last.text.length - 1);
            }
            if (RegExp(r'[,.;:!?]').firstMatch(word)?.end == word.length) {
              nodes.add(
                  wordNode.copyWith(text: word.substring(0, word.length - 1)));
              nodes.add(wordNode.copyWith(
                  text: '${word.substring(word.length - 1)}',
                  isSelectable: false));
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
                setState(() {
                  selectedIndex = nodes.indexOf(n);
                });
              })
            .span;
      } else {
        return n.span;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: RichText(
        text: TextSpan(
          children: _createChildren(widget.text),
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

  TextNode(
      {this.text = '',
      this.isWidget = false,
      this.isSelectable = false,
      this.isRef = false,
      this.isItalic = false,
      this.isBold = false,
      this.color = Colors.black,
      this.isUnderline = false,
      this.isSelected = false,
      this.onTap});

  InlineSpan get span {
    if (isWidget) return const WidgetSpan(child: Icon(Icons.volume_up_rounded));
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

  TextNode copyWith({
    String? text,
    bool? isWidget,
    bool? isSelectable,
    bool? isRef,
    bool? isItalic,
    bool? isBold,
    Color? color,
    bool? isUnderline,
    bool? isSelected,
    Function()? onTap,
  }) {
    return TextNode(
      text: text ?? this.text,
      isWidget: isWidget ?? this.isWidget,
      isSelectable: isSelectable ?? this.isSelectable,
      isRef: isRef ?? this.isRef,
      isItalic: isItalic ?? this.isItalic,
      isBold: isBold ?? this.isBold,
      color: color ?? this.color,
      isUnderline: isUnderline ?? this.isUnderline,
      isSelected: isSelected ?? this.isSelected,
      onTap: onTap ?? this.onTap,
    );
  }
}
