import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension WizzDeckCMtoDM on WizzDeckCM {
  WizzDeckDM toDomain() {
    return WizzDeckDM(
        name: name,
        fromLanguage: fromLanguage,
        toLanguage: toLanguage,
        cards: cards.map((c) => c.toDomain()).toList());
  }
}

extension WizzCardCmtoDm on WizzCardCM {
  WizzCardDM toDomain() {
    return WizzCardDM(
        word: word,
        meaning: meaning,
        examples: examples,
        fullText: fullText,
        showFrequency: showFrequency?.toDomain() ?? ShowFrequencyDM.normal);
  }
}

extension ShowFrequencyCMtoDM on ShowFrequencyCM {
  ShowFrequencyDM toDomain() {
    switch (this) {
      case ShowFrequencyCM.low:
        return ShowFrequencyDM.low;
      case ShowFrequencyCM.normal:
        return ShowFrequencyDM.normal;
      case ShowFrequencyCM.high:
        return ShowFrequencyDM.high;
    }
  }
}
