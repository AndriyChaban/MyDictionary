import 'wizz_card_dm.dart';
import 'package:equatable/equatable.dart';

class WizzDeckDM extends Equatable {
  final String name;
  final String fromLanguage;
  final String toLanguage;
  final List<WizzCardDM> cards;
  final int sessionNumber;
  final DateTime timeStamp;

  const WizzDeckDM(
      {required this.name,
      required this.fromLanguage,
      required this.toLanguage,
      required this.cards,
      this.sessionNumber = 0,
      required this.timeStamp});

  @override
  List<Object> get props =>
      [name, fromLanguage, toLanguage, cards, sessionNumber, timeStamp];

  WizzDeckDM copyWith({
    String? name,
    String? fromLanguage,
    String? toLanguage,
    List<WizzCardDM>? cards,
    int? sessionNumber,
    DateTime? timeStamp,
  }) {
    return WizzDeckDM(
      name: name ?? this.name,
      fromLanguage: fromLanguage ?? this.fromLanguage,
      toLanguage: toLanguage ?? this.toLanguage,
      cards: cards ?? this.cards,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }
}
