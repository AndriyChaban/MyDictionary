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
}
