import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_screen/src/translation_screen_cubit.dart';

class StyledTappableText extends StatefulWidget {
  StyledTappableText(
      {Key? key,
      required this.text,
      required this.onWordTap,
      required this.index,
      this.multiSelect = false})
      : super(key: key);
  final String text;
  final void Function(String) onWordTap;
  final bool multiSelect;
  final int index;

  @override
  State<StyledTappableText> createState() => _StyledTappableTextState();
}

class _StyledTappableTextState extends State<StyledTappableText> {
  // Set<int> selectedIndices = {-1};

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

  void _onSelectableWordTap(String text, int nodeIndex, RenderBox renderBox) {
    final cubit = context.read<TranslationScreenCubit>();
    if (cubit.state.currentCardIndex != widget.index ||
        cubit.state.currentWordIndex != nodeIndex) {
      cubit.setSelectedWordIndices(
          cardIndex: widget.index, nodeIndex: nodeIndex);
      cubit.setSmallBoxParameters(text: text, renderBox: renderBox);
    } else {
      cubit.removeSmallBox();
    }
  }

  void _onRefTap(String word) {
    setState(() {
      // selectedIndices = {-1};
      context.read<TranslationScreenCubit>().removeSmallBox();
      widget.onWordTap(word);
    });
  }

  List<InlineSpan> _createChildren(String text) {
    final lines = text.split('\n');
    final nodes = <TextNode>[];
    // final spans = <InlineSpan>[];
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
          if (spaces.isNotEmpty) nodes.add(TextNode()..text = spaces);
        }
      }
      line = line.replaceAll(RegExp(r'<.?m\d?>'), '');

      /// get text patches
      final textPatchRegExp = RegExp(
        r'(?<=[\t>])([^<>]+)(?![^<])',
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
        if (betweenRef) {
          final node = TextNode()
            ..isRef = true
            ..color = Colors.blue
            ..text = textMatch.group(1)!;
          nodes.add(node);
        } else {
          final words = textMatch.group(1)!.split(RegExp(r'\s'));
          for (var word in words) {
            if (word.isEmpty) continue;
            final wordNode = TextNode()
              ..isSoundWidget = betweenS
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
                  text: word.substring(word.length - 1), isSelectable: false));
            } else {
              nodes.add(wordNode);
            }
            if (!word.endsWith('(')) nodes.add(TextNode()..text = ' ');
          }
        }
      }
      nodes.add(TextNode()..text = '\n');
    }
    final cubit = context.read<TranslationScreenCubit>();
    return nodes.map((n) {
      // if (n.isRef) return (n..onTap = () => widget.onWordTap(n.text)).span;
      if (n.isSelectable) {
        return (n
              ..index = nodes.indexOf(n)
              ..isSelected = cubit.state.currentCardIndex == widget.index &&
                  cubit.state.currentWordIndex == n.index
              ..onTap = n.isRef ? _onRefTap : _onSelectableWordTap)
            .span;
      } else if (n.isRef) {
        return (n..onTap = _onRefTap).span;
      } else {
        return n.span;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: _createChildren(widget.text),
      ),
    );
  }
}

class TextNode {
  int index = -1;
  String text = '';
  bool isSoundWidget = false;
  bool isSelectable = false;
  bool isRef = false;
  bool isItalic = false;
  bool isBold = false;
  Color color = Colors.black;
  bool isUnderline = false;
  bool isSelected = false;
  Function? onTap;

  TextNode(
      {this.text = '',
      this.isSoundWidget = false,
      this.isSelectable = false,
      this.isRef = false,
      this.isItalic = false,
      this.isBold = false,
      this.color = Colors.black,
      this.isUnderline = false,
      this.isSelected = false,
      this.onTap});

  InlineSpan get span {
    if (isSoundWidget) {
      return const WidgetSpan(child: Icon(Icons.volume_up_rounded));
    }
    if (text == '\n') return const TextSpan(text: '\n');
    return WidgetSpan(
      child: SelectableSpanWidget(
          index: index,
          isRef: isRef,
          onTap: onTap,
          text: text,
          isSelected: isSelected,
          isItalic: isItalic,
          isBold: isBold,
          isUnderline: isUnderline,
          color: color),
    );
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
      isSoundWidget: isWidget ?? this.isSoundWidget,
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

class SelectableSpanWidget extends StatelessWidget {
  const SelectableSpanWidget({
    super.key,
    this.index = -1,
    this.isRef = false,
    this.onTap,
    required this.text,
    this.isSelected = false,
    this.isItalic = false,
    this.isBold = false,
    this.isUnderline = false,
    required this.color,
  });

  final Function? onTap;
  final String text;
  final bool isSelected;
  final bool isRef;
  final bool isItalic;
  final bool isBold;
  final bool isUnderline;
  final Color color;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? () {
              if (!isRef) {
                final renderBox = context.findRenderObject() as RenderBox;
                onTap!(text, index, renderBox);
              } else {
                onTap!(text);
              }
            }
          : () {},
      child: Text(
        text,
        style: TextStyle(
          height: 0.7,
          backgroundColor: isSelected ? Colors.yellow : Colors.transparent,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          decoration:
              isUnderline ? TextDecoration.underline : TextDecoration.none,
          color: color,
        ),
      ),
    );
  }
}
