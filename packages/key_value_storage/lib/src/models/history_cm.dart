import 'package:hive/hive.dart';

part 'history_cm.g.dart';

@HiveType(typeId: 5)
class HistoryDictionaryCM extends HiveObject {
  @HiveField(0)
  String languageFrom;
  @HiveField(1)
  String languageTo;
  @HiveField(2)
  List<HistoryCardCM> cards;

  HistoryDictionaryCM({
    required this.languageFrom,
    required this.languageTo,
    this.cards = const <HistoryCardCM>[],
  });
}

@HiveType(typeId: 6)
class HistoryCardCM extends HiveObject {
  @HiveField(0)
  String headword;
  @HiveField(1)
  String text;
  @HiveField(2)
  String dictionaryName;

  HistoryCardCM({
    required this.headword,
    required this.text,
    required this.dictionaryName,
  });
}
