import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension DictionaryDomainToCache on DictionaryDM {
  DictionaryCM toCacheModel() => DictionaryCM(
      dictionaryName: name,
      indexLanguage: indexLanguage,
      contentLanguage: contentLanguage);
}
