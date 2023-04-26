import 'package:hive/hive.dart';

part 'dictionary_cm.g.dart';

@HiveType(typeId: 0)
class DictionaryCM extends HiveObject {
  @HiveField(0)
  String dictionaryName;
  @HiveField(1)
  String indexLanguage;
  @HiveField(2)
  String contentLanguage;
  @HiveField(3)
  bool active;
  @HiveField(4)
  int entriesNumber;

  DictionaryCM({
    required this.dictionaryName,
    required this.indexLanguage,
    required this.contentLanguage,
    this.entriesNumber = 0,
    this.active = false,
  });
}
