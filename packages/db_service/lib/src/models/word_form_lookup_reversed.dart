import 'package:isar/isar.dart';
part 'word_form_lookup_reversed.g.dart';

@collection
class WordFormLookupReversedIsar {
  Id? id = Isar.autoIncrement;

  @Index(unique: true)
  String? wordForm;

  String? infinitive;
}
