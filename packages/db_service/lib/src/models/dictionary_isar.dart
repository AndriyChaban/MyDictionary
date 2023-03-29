import 'card_db.dart';

class DictionaryDB {
  String dictionaryName;
  List<CardDB> cardsList;

  DictionaryDB({
    required this.dictionaryName,
    this.cardsList = const [],
  });
}
