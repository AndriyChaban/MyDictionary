import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension WizzDeckDMtoCM on WizzDeckDM {
  WizzDeckCM toCache() {
    return WizzDeckCM(
        name: name,
        fromLanguage: fromLanguage,
        toLanguage: toLanguage,
        cards: cards.map((c) => c.toCache()).toList(),
        sessionNumber: sessionNumber,
        timeStamp: timeStamp);
  }
}

extension WizzCardDMtoCM on WizzCardDM {
  WizzCardCM toCache() {
    return WizzCardCM(
        word: word,
        meaning: meaning,
        examples: examples,
        fullText: fullText,
        level: level);
    // showFrequency: showFrequency?.toCache() ?? ShowFrequencyCM.normal);
  }
}

// extension ShowFrequencyDMtoCM on ShowFrequencyDM {
//   ShowFrequencyCM toCache() {
//     switch (this) {
//       case ShowFrequencyDM.low:
//         return ShowFrequencyCM.low;
//       case ShowFrequencyDM.normal:
//         return ShowFrequencyCM.normal;
//       case ShowFrequencyDM.high:
//         return ShowFrequencyCM.high;
//     }
//   }
// }
