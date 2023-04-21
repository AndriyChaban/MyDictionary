import 'dart:io';

import 'package:xml/xml.dart';

import 'package:key_value_storage/key_value_storage.dart';
import 'package:dictionary_provider/dictionary_provider.dart';
import 'package:domain_models/domain_models.dart';

import './mappers/mappers.dart';

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

  Future<WizzDeckDM> importWizzDeck(String filePath,
      {bool force = false}) async {
    try {
      final fileAsString = File(filePath).readAsStringSync();
      final document = XmlDocument.parse(fileAsString);
      final rootAttributes = document.rootElement.attributes;
      final name =
          rootAttributes.firstWhere((a) => a.localName == 'name').value;
      final fromLanguage =
          rootAttributes.firstWhere((a) => a.localName == 'fromLanguage').value;
      final toLanguage =
          rootAttributes.firstWhere((a) => a.localName == 'toLanguage').value;
      final sessionNumber = int.parse(rootAttributes
          .firstWhere((a) => a.localName == 'sessionNumber')
          .value);
      final cards = <WizzCardDM>[];
      final cardsXml = document.rootElement.descendantElements.first;
      for (var cardXml in cardsXml.children) {
        final children = cardXml.descendantElements;
        cards.add(WizzCardDM(
          word: cardXml.attributes
              .firstWhere((a) => a.name.toString() == 'word')
              .value,
          level: int.parse(cardXml.attributes
              .firstWhere((a) => a.name.toString() == 'level')
              .value),
          fullText: children
              .firstWhere((element) => element.name.toString() == 'fullText')
              .text,
          meaning: children
              .firstWhere((element) => element.name.toString() == 'meaning')
              .text,
          examples: children
              .firstWhere((element) => element.name.toString() == 'examples')
              .text,
        ));
      }
      final deck = WizzDeckDM(
          name: name,
          fromLanguage: fromLanguage,
          toLanguage: toLanguage,
          sessionNumber: sessionNumber,
          cards: cards);
      final wizzDecksBox = await keyValueStorage.getWizzDecksBox();
      if (wizzDecksBox.containsKey(deckKeyFormat(deck)) && !force) {
        throw XmlFileParsingKeyExistsException();
      }
      wizzDecksBox.put(deckKeyFormat(deck), deck.toCache());
      return deck;
    } on XmlException {
      throw XmlFileParsingException();
    } catch (e) {
      rethrow;
    }
  }

  void exportWizzDeck({required WizzDeckDM deck, required String filePath}) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('deck', nest: () {
      builder.attribute('name', deck.name);
      builder.attribute('fromLanguage', deck.fromLanguage);
      builder.attribute('toLanguage', deck.toLanguage);
      builder.attribute('sessionNumber', deck.sessionNumber);
      builder.element('cards', nest: () {
        for (var card in deck.cards) {
          builder.element('card', nest: () {
            builder.attribute('word', card.word);
            builder.attribute('level', card.level);
            builder.element('meaning', nest: () {
              builder.text(card.meaning);
            });
            builder.element('examples', nest: () {
              if (card.examples != null && card.examples!.isNotEmpty) {
                builder.text(card.examples!);
              }
            });
            builder.element('fullText', nest: () {
              if (card.fullText != null && card.fullText!.isNotEmpty) {
                builder.text(card.fullText!);
              }
            });
          });
        }
      });
    });
    final document = builder.buildDocument();
    final file = File(filePath)..createSync();
    file.writeAsString(document.toString());
  }

  void saveTrainingProgress(
      {required WizzDeckDM deck, required List<WizzCardDM> cards}) async {
    final wizzDecksBox = await keyValueStorage.getWizzDecksBox();
    for (var card in cards) {
      final index =
          deck.cards.indexWhere((element) => element.word == card.word);
      deck.cards
        ..removeAt(index)
        ..insert(index, card);
    }
    final updatedDeck = deck.copyWith(sessionNumber: deck.sessionNumber + 1);
    wizzDecksBox.put(deckKeyFormat(deck), updatedDeck.toCache());
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
