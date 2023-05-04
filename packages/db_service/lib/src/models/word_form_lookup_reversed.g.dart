// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_form_lookup_reversed.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetWordFormLookupReversedIsarCollection on Isar {
  IsarCollection<WordFormLookupReversedIsar> get wordFormLookupReversedIsars =>
      this.collection();
}

const WordFormLookupReversedIsarSchema = CollectionSchema(
  name: r'WordFormLookupReversedIsar',
  id: 2945128691486335794,
  properties: {
    r'infinitive': PropertySchema(
      id: 0,
      name: r'infinitive',
      type: IsarType.string,
    ),
    r'wordForm': PropertySchema(
      id: 1,
      name: r'wordForm',
      type: IsarType.string,
    )
  },
  estimateSize: _wordFormLookupReversedIsarEstimateSize,
  serialize: _wordFormLookupReversedIsarSerialize,
  deserialize: _wordFormLookupReversedIsarDeserialize,
  deserializeProp: _wordFormLookupReversedIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'wordForm': IndexSchema(
      id: -4807961851256686043,
      name: r'wordForm',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'wordForm',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _wordFormLookupReversedIsarGetId,
  getLinks: _wordFormLookupReversedIsarGetLinks,
  attach: _wordFormLookupReversedIsarAttach,
  version: '3.0.5',
);

int _wordFormLookupReversedIsarEstimateSize(
  WordFormLookupReversedIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.infinitive;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.wordForm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _wordFormLookupReversedIsarSerialize(
  WordFormLookupReversedIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.infinitive);
  writer.writeString(offsets[1], object.wordForm);
}

WordFormLookupReversedIsar _wordFormLookupReversedIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordFormLookupReversedIsar();
  object.id = id;
  object.infinitive = reader.readStringOrNull(offsets[0]);
  object.wordForm = reader.readStringOrNull(offsets[1]);
  return object;
}

P _wordFormLookupReversedIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wordFormLookupReversedIsarGetId(WordFormLookupReversedIsar object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _wordFormLookupReversedIsarGetLinks(
    WordFormLookupReversedIsar object) {
  return [];
}

void _wordFormLookupReversedIsarAttach(
    IsarCollection<dynamic> col, Id id, WordFormLookupReversedIsar object) {
  object.id = id;
}

extension WordFormLookupReversedIsarByIndex
    on IsarCollection<WordFormLookupReversedIsar> {
  Future<WordFormLookupReversedIsar?> getByWordForm(String? wordForm) {
    return getByIndex(r'wordForm', [wordForm]);
  }

  WordFormLookupReversedIsar? getByWordFormSync(String? wordForm) {
    return getByIndexSync(r'wordForm', [wordForm]);
  }

  Future<bool> deleteByWordForm(String? wordForm) {
    return deleteByIndex(r'wordForm', [wordForm]);
  }

  bool deleteByWordFormSync(String? wordForm) {
    return deleteByIndexSync(r'wordForm', [wordForm]);
  }

  Future<List<WordFormLookupReversedIsar?>> getAllByWordForm(
      List<String?> wordFormValues) {
    final values = wordFormValues.map((e) => [e]).toList();
    return getAllByIndex(r'wordForm', values);
  }

  List<WordFormLookupReversedIsar?> getAllByWordFormSync(
      List<String?> wordFormValues) {
    final values = wordFormValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'wordForm', values);
  }

  Future<int> deleteAllByWordForm(List<String?> wordFormValues) {
    final values = wordFormValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'wordForm', values);
  }

  int deleteAllByWordFormSync(List<String?> wordFormValues) {
    final values = wordFormValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'wordForm', values);
  }

  Future<Id> putByWordForm(WordFormLookupReversedIsar object) {
    return putByIndex(r'wordForm', object);
  }

  Id putByWordFormSync(WordFormLookupReversedIsar object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'wordForm', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWordForm(List<WordFormLookupReversedIsar> objects) {
    return putAllByIndex(r'wordForm', objects);
  }

  List<Id> putAllByWordFormSync(List<WordFormLookupReversedIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'wordForm', objects, saveLinks: saveLinks);
  }
}

extension WordFormLookupReversedIsarQueryWhereSort on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QWhere> {
  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WordFormLookupReversedIsarQueryWhere on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QWhereClause> {
  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> wordFormIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'wordForm',
        value: [null],
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> wordFormIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'wordForm',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> wordFormEqualTo(String? wordForm) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'wordForm',
        value: [wordForm],
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterWhereClause> wordFormNotEqualTo(String? wordForm) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordForm',
              lower: [],
              upper: [wordForm],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordForm',
              lower: [wordForm],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordForm',
              lower: [wordForm],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordForm',
              lower: [],
              upper: [wordForm],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WordFormLookupReversedIsarQueryFilter on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QFilterCondition> {
  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'infinitive',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'infinitive',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'infinitive',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'infinitive',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'infinitive',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'infinitive',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'infinitive',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'infinitive',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
          QAfterFilterCondition>
      infinitiveContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'infinitive',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
          QAfterFilterCondition>
      infinitiveMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'infinitive',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'infinitive',
        value: '',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> infinitiveIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'infinitive',
        value: '',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wordForm',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wordForm',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordForm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wordForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wordForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
          QAfterFilterCondition>
      wordFormContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wordForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
          QAfterFilterCondition>
      wordFormMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wordForm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordForm',
        value: '',
      ));
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterFilterCondition> wordFormIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wordForm',
        value: '',
      ));
    });
  }
}

extension WordFormLookupReversedIsarQueryObject on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QFilterCondition> {}

extension WordFormLookupReversedIsarQueryLinks on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QFilterCondition> {}

extension WordFormLookupReversedIsarQuerySortBy on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QSortBy> {
  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> sortByInfinitive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infinitive', Sort.asc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> sortByInfinitiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infinitive', Sort.desc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> sortByWordForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordForm', Sort.asc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> sortByWordFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordForm', Sort.desc);
    });
  }
}

extension WordFormLookupReversedIsarQuerySortThenBy on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QSortThenBy> {
  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> thenByInfinitive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infinitive', Sort.asc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> thenByInfinitiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'infinitive', Sort.desc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> thenByWordForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordForm', Sort.asc);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QAfterSortBy> thenByWordFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordForm', Sort.desc);
    });
  }
}

extension WordFormLookupReversedIsarQueryWhereDistinct on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QDistinct> {
  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QDistinct> distinctByInfinitive({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'infinitive', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, WordFormLookupReversedIsar,
      QDistinct> distinctByWordForm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordForm', caseSensitive: caseSensitive);
    });
  }
}

extension WordFormLookupReversedIsarQueryProperty on QueryBuilder<
    WordFormLookupReversedIsar, WordFormLookupReversedIsar, QQueryProperty> {
  QueryBuilder<WordFormLookupReversedIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, String?, QQueryOperations>
      infinitiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'infinitive');
    });
  }

  QueryBuilder<WordFormLookupReversedIsar, String?, QQueryOperations>
      wordFormProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordForm');
    });
  }
}
