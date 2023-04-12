import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:wizz_training_module/src/mappers/mappers.dart';

class WizzTrainingModule {
  final KeyValueStorage keyValueStorage;
  final DictionaryProvider dictionaryProvider;

  WizzTrainingModule({
    required this.keyValueStorage,
    required this.dictionaryProvider,
  });

  Future<List<WizzDeckDM>> getListOfAllDecks() async {
    final wizzBox = await keyValueStorage.getWizzDecksBox();
    return wizzBox.values.map((d) => d.toDomain()).toList();
  }

  Future<void> createNewWizzDeck(WizzDeckDM deck) async {
    final wizzBox = await keyValueStorage.getWizzDecksBox();
    wizzBox.put(deckKeyFormat(deck), deck.toCache());
  }

  Future<void> editWizzDeck(WizzDeckDM oldDeck, WizzDeckDM newDeck) async {
    final wizzBox = await keyValueStorage.getWizzDecksBox();
    await wizzBox.delete(deckKeyFormat(oldDeck));
    await wizzBox.put(deckKeyFormat(newDeck), newDeck.toCache());
// wizzBox.
  }

  Future<void> deleteWizzDeck(WizzDeckDM deck) async {
    final wizzBox = await keyValueStorage.getWizzDecksBox();
    wizzBox.delete(deckKeyFormat(deck));
  }

  Future<List<WizzCardDM>?> getListOfCards(WizzDeckDM deck) async {
    final deckEntry =
        (await keyValueStorage.getWizzDecksBox()).get(deckKeyFormat(deck));
    return deckEntry?.cards.map((c) => c.toDomain()).toList();
  }

  Future<void> createNewCard(
      {required WizzCardDM card, required WizzDeckDM deck}) async {
    final wizzBox = await keyValueStorage.getWizzDecksBox();
    final deckEntry = wizzBox.get(deckKeyFormat(deck));
    deckEntry?.cards.add(card.toCache());
    await deckEntry?.save();
  }

  Future<bool> deleteCard(
      {required WizzCardDM card, required WizzDeckDM deck}) async {
    final wizzBox = await keyValueStorage.getWizzDecksBox();
    final deckEntry = wizzBox.get(deckKeyFormat(deck));
    final index = deckEntry?.cards.indexWhere((c) => c.word == card.word);
    if (index != null && deckEntry != null) {
      deckEntry.cards.removeAt(index);
      await deckEntry.save();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editCard(
      {required WizzCardDM oldCard,
      required WizzCardDM newCard,
      required WizzDeckDM deck}) async {
    final wizzBox = await keyValueStorage.getWizzDecksBox();
    final deckEntry = wizzBox.get(deckKeyFormat(deck));
    final index = deckEntry?.cards.indexWhere((c) => c.word == oldCard.word);
    if (index != null && deckEntry != null) {
      deckEntry.cards.removeAt(index);
      deckEntry.cards.insert(index, newCard.toCache());
      await deckEntry.save();
      return true;
    } else {
      return false;
    }
  }
}

String deckKeyFormat(WizzDeckDM deck) {
  return '${deck.name}-${deck.fromLanguage}-${deck.toLanguage}';
}
