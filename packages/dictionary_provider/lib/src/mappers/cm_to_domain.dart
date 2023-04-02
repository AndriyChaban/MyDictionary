import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension DictionaryCacheToDomain on DictionaryCM {
  DictionaryDM toDomainModel() => DictionaryDM(
      name: dictionaryName,
      indexLanguage: indexLanguage,
      contentLanguage: contentLanguage,
      active: active);
}

extension HistoryCardCacheToDomain on HistoryCardCM {
  CardDM toDomainModel() => CardDM(headword: this.headword, text: this.text);
}
