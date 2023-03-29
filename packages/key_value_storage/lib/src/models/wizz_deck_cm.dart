import 'package:hive/hive.dart';

part 'wizz_deck_cm.g.dart';

@HiveType(typeId: 1)
class WizzDeckCM extends HiveObject {
  @HiveField(0)
  final String translateFromLanguage;
  @HiveField(1)
  final String translateToLanguage;
  @HiveField(2)
  final List<WizzCardCM> cardsList;

  WizzDeckCM({
    required this.translateFromLanguage,
    required this.translateToLanguage,
    this.cardsList = const [],
  });
}

@HiveType(typeId: 2)
class WizzCardCM extends HiveObject {
  @HiveField(0)
  final String headword;
  @HiveField(1)
  final List<String> translations;

  WizzCardCM({
    required this.headword,
    required this.translations,
  });
}
