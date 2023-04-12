import 'wizz_card_dm.dart';
import 'package:equatable/equatable.dart';

class WizzDeckDM extends Equatable {
  final String name;
  final String fromLanguage;
  final String toLanguage;
  final List<WizzCardDM> cards;

  const WizzDeckDM({
    required this.name,
    required this.fromLanguage,
    required this.toLanguage,
    required this.cards,
  });

  @override
  List<Object> get props => [name, fromLanguage, toLanguage, cards];
}
