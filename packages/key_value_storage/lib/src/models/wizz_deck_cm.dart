import 'package:hive/hive.dart';

part 'wizz_deck_cm.g.dart';

@HiveType(typeId: 1)
class WizzDeckCM extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String fromLanguage;
  @HiveField(2)
  final String toLanguage;
  @HiveField(3)
  final List<WizzCardCM> cards;
  @HiveField(4)
  final int sessionNumber;
  @HiveField(5)
  final DateTime timeStamp;

  WizzDeckCM({
    this.sessionNumber = 0,
    required this.name,
    required this.fromLanguage,
    required this.toLanguage,
    required this.cards,
    required this.timeStamp,
  });
}

@HiveType(typeId: 2)
class WizzCardCM extends HiveObject {
  @HiveField(0)
  final String word;
  @HiveField(1)
  final String meaning;
  @HiveField(2)
  final String? examples;
  @HiveField(3)
  final String? fullText;
  @HiveField(4)
  final int? level;

  WizzCardCM(
      {required this.word,
      required this.meaning,
      this.examples,
      this.fullText,
      this.level
      // this.showFrequency = ShowFrequencyCM.normal,
      });
}

// @HiveType(typeId: 7)
// enum ShowFrequencyCM {
//   @HiveField(0)
//   low,
//   @HiveField(1)
//   normal,
//   @HiveField(2)
//   high
// }
