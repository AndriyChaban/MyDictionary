import 'package:db_service/db_service.dart';
import 'package:domain_models/domain_models.dart';

extension DictionaryDomainToDB on DictionaryDM {
  DictionaryDB toDBModel() {
    return DictionaryDB(
        dictionaryName: this.name,
        cardsList: this.cards.map((card) => card.toDBModel()).toList());
  }
}

extension CardDomainToDB on CardDM {
  CardDB toDBModel() {
    return CardDB()
      ..headword = this.headword
      ..text = this.text;
  }
}
