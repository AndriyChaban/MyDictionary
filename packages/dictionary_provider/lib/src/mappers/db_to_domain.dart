import 'package:db_service/db_service.dart';
import 'package:domain_models/domain_models.dart';

// extension DictionaryDBToDomain on DictionaryDB {
//   DictionaryDM toDomainModel() => DictionaryDM(name: this.dictionaryName, indexLanguage: this., contentLanguage: contentLanguage)
// }

extension CardToDomain on Card {
  CardDM toDomainModel() =>
      CardDM(headword: this.headword!, text: this.fullCardText!);
}
