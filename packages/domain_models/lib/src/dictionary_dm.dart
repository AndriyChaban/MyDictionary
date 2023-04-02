import 'package:equatable/equatable.dart';

import 'models.dart';

class DictionaryDM extends Equatable {
  final String name;
  final String indexLanguage;
  final String contentLanguage;
  final List<CardDM> cards;
  final bool active;

  DictionaryDM(
      {required this.name,
      required this.indexLanguage,
      required this.contentLanguage,
      this.active = false,
      this.cards = const <CardDM>[]});

  @override
  List<Object> get props =>
      [name, indexLanguage, contentLanguage, cards, active];

  DictionaryDM copyWith({
    String? name,
    String? indexLanguage,
    String? contentLanguage,
    List<CardDM>? cards,
    bool? active,
  }) {
    return DictionaryDM(
      name: name ?? this.name,
      indexLanguage: indexLanguage ?? this.indexLanguage,
      contentLanguage: contentLanguage ?? this.contentLanguage,
      cards: cards ?? this.cards,
      active: active ?? this.active,
    );
  }
}
