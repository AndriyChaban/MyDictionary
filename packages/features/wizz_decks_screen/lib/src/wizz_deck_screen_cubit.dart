import 'package:domain_models/domain_models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:wizz_decks_screen/src/wizz_deck_screen_state.dart';
import 'package:wizz_training_module/wizz_training_module.dart';

class WizzDeckScreenCubit extends Cubit<WizzDeckScreenState> {
  final WizzTrainingModule wizzTrainingModule;
  String? _temp;

  WizzDeckScreenCubit({required this.wizzTrainingModule})
      : super(const WizzDeckScreenStateInitial());

  Future<List<WizzDeckDM>> getListOfAvailableDecks(
      {String? fromLanguage, String? toLanguage, String? errorMessage}) async {
    fromLanguage = fromLanguage ?? state.fromLanguage;
    toLanguage = toLanguage ?? state.toLanguage;
    List<WizzDeckDM> listOfDecks =
        (await wizzTrainingModule.getListOfAllDecks());
    // ..sort((a, b) => a.name.compareTo(b.name));
    if (fromLanguage != 'all' && toLanguage == 'all') {
      listOfDecks =
          listOfDecks.where((d) => d.fromLanguage == fromLanguage).toList();
    } else if (fromLanguage == 'all' && toLanguage != 'all') {
      listOfDecks =
          listOfDecks.where((d) => d.toLanguage == toLanguage).toList();
    } else if (fromLanguage != 'all' && toLanguage != 'all') {
      listOfDecks = listOfDecks
          .where((d) =>
              d.toLanguage == toLanguage && d.fromLanguage == fromLanguage)
          .toList();
    }
    emit(state.copyWith(
        listOfDecks: listOfDecks,
        fromLanguage: fromLanguage,
        toLanguage: toLanguage,
        errorMessage: errorMessage));
    return listOfDecks;
  }

  void createNewWizzDeck(WizzDeckDM deck) async {
    try {
      await wizzTrainingModule.createNewWizzDeck(deck);
      getListOfAvailableDecks();
    } catch (e) {
      // print(e);
    }
  }

  void editWizzDeck(
      {required WizzDeckDM oldDeck, required WizzDeckDM newDeck}) async {
    await wizzTrainingModule.editWizzDeck(oldDeck, newDeck);
    getListOfAvailableDecks();
  }

  void deleteWizzDeck(WizzDeckDM deck) async {
    await wizzTrainingModule.deleteWizzDeck(deck);
    getListOfAvailableDecks(
        errorMessage: 'Successfully deleted deck ${deck.name}');
  }

  void exportWizzDeck(WizzDeckDM deck) async {
    final folder = await FilePicker.platform.getDirectoryPath();
    if (folder != null) {
      wizzTrainingModule.exportWizzDeck(
          deck: deck,
          filePath: join(folder,
              '${deck.name}-${deck.fromLanguage}-${deck.toLanguage}.xml'));
    }
  }

  Future<void> importWizzDeck({bool force = false}) async {
    FilePickerResult? file;
    if (_temp == null) {
      file = await FilePicker.platform
          .pickFiles(allowedExtensions: ['xml'], type: FileType.custom);
      _temp = file?.paths.first;
    }
    if (_temp != null) {
      try {
        final newDeck =
            await wizzTrainingModule.importWizzDeck(_temp!, force: force);
        _temp = null;
        getListOfAvailableDecks(
            errorMessage:
                'Successfully added deck "${newDeck.name.toCapital()}"');
      } on XmlFileParsingKeyExistsException {
        throw XmlFileParsingKeyExistsException();
      } on XmlFileParsingException {
        emit(state.copyWith(errorMessage: 'Could not parse the file'));
      }
    }
  }

  Future<String?> validateNameOfDeck(
      {required String? name,
      required String fromLanguage,
      required String toLanguage}) async {
    String? validation;
    if (name == null || name.isEmpty) return 'Please enter name';
    final list = await wizzTrainingModule.getListOfAllDecks();
    validation = list
            .where((d) =>
                d.name == name &&
                d.fromLanguage == fromLanguage &&
                d.toLanguage == toLanguage)
            .isEmpty
        ? null
        : 'This name already exists';
    return validation;
  }
}
