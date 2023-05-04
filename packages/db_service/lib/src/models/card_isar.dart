import 'package:isar/isar.dart';
part 'card_isar.g.dart';

@collection
class CardIsar {
  Id? id = Isar.autoIncrement;

  @Index(unique: true)
  String? headword;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get examplesWords =>
      Isar.splitWords(getTextOfExamples(fullCardText ?? ''));

  String? fullCardText;
}

String getTextOfExamples(String? cardText) {
  if (cardText == null) return '';
  final exampleZonePattern = RegExp(r'\[ex\](.*)\[/ex\]');
  final examples = exampleZonePattern.allMatches(cardText).map((match) =>
      match.group(1) != null
          ? match.group(1)?.toLowerCase().replaceAll(RegExp(r'\[.*\]'), '')
          : '');
  final joinedExamples = examples.join(' ');
  return joinedExamples;
}
