// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCardIsarCollection on Isar {
  IsarCollection<CardIsar> get cardIsars => this.collection();
}

const CardIsarSchema = CollectionSchema(
  name: r'CardIsar',
  id: 6914043207727543395,
  properties: {
    r'examplesWords': PropertySchema(
      id: 0,
      name: r'examplesWords',
      type: IsarType.stringList,
    ),
    r'fullCardText': PropertySchema(
      id: 1,
      name: r'fullCardText',
      type: IsarType.string,
    ),
    r'headword': PropertySchema(
      id: 2,
      name: r'headword',
      type: IsarType.string,
    )
  },
  estimateSize: _cardIsarEstimateSize,
  serialize: _cardIsarSerialize,
  deserialize: _cardIsarDeserialize,
  deserializeProp: _cardIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'headword': IndexSchema(
      id: 4708330669790705042,
      name: r'headword',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'headword',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'examplesWords': IndexSchema(
      id: 838288806847119867,
      name: r'examplesWords',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'examplesWords',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cardIsarGetId,
  getLinks: _cardIsarGetLinks,
  attach: _cardIsarAttach,
  version: '3.0.5',
);

int _cardIsarEstimateSize(
  CardIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.examplesWords.length * 3;
  {
    for (var i = 0; i < object.examplesWords.length; i++) {
      final value = object.examplesWords[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.fullCardText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.headword;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cardIsarSerialize(
  CardIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.examplesWords);
  writer.writeString(offsets[1], object.fullCardText);
  writer.writeString(offsets[2], object.headword);
}

CardIsar _cardIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardIsar();
  object.fullCardText = reader.readStringOrNull(offsets[1]);
  object.headword = reader.readStringOrNull(offsets[2]);
  object.id = id;
  return object;
}

P _cardIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cardIsarGetId(CardIsar object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _cardIsarGetLinks(CardIsar object) {
  return [];
}

void _cardIsarAttach(IsarCollection<dynamic> col, Id id, CardIsar object) {
  object.id = id;
}

extension CardIsarByIndex on IsarCollection<CardIsar> {
  Future<CardIsar?> getByHeadword(String? headword) {
    return getByIndex(r'headword', [headword]);
  }

  CardIsar? getByHeadwordSync(String? headword) {
    return getByIndexSync(r'headword', [headword]);
  }

  Future<bool> deleteByHeadword(String? headword) {
    return deleteByIndex(r'headword', [headword]);
  }

  bool deleteByHeadwordSync(String? headword) {
    return deleteByIndexSync(r'headword', [headword]);
  }

  Future<List<CardIsar?>> getAllByHeadword(List<String?> headwordValues) {
    final values = headwordValues.map((e) => [e]).toList();
    return getAllByIndex(r'headword', values);
  }

  List<CardIsar?> getAllByHeadwordSync(List<String?> headwordValues) {
    final values = headwordValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'headword', values);
  }

  Future<int> deleteAllByHeadword(List<String?> headwordValues) {
    final values = headwordValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'headword', values);
  }

  int deleteAllByHeadwordSync(List<String?> headwordValues) {
    final values = headwordValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'headword', values);
  }

  Future<Id> putByHeadword(CardIsar object) {
    return putByIndex(r'headword', object);
  }

  Id putByHeadwordSync(CardIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'headword', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHeadword(List<CardIsar> objects) {
    return putAllByIndex(r'headword', objects);
  }

  List<Id> putAllByHeadwordSync(List<CardIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'headword', objects, saveLinks: saveLinks);
  }
}

extension CardIsarQueryWhereSort on QueryBuilder<CardIsar, CardIsar, QWhere> {
  QueryBuilder<CardIsar, CardIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhere> anyExamplesWordsElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'examplesWords'),
      );
    });
  }
}

extension CardIsarQueryWhere on QueryBuilder<CardIsar, CardIsar, QWhereClause> {
  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> headwordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'headword',
        value: [null],
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> headwordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'headword',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> headwordEqualTo(
      String? headword) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'headword',
        value: [headword],
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause> headwordNotEqualTo(
      String? headword) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'headword',
              lower: [],
              upper: [headword],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'headword',
              lower: [headword],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'headword',
              lower: [headword],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'headword',
              lower: [],
              upper: [headword],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementEqualTo(String examplesWordsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'examplesWords',
        value: [examplesWordsElement],
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementNotEqualTo(String examplesWordsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'examplesWords',
              lower: [],
              upper: [examplesWordsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'examplesWords',
              lower: [examplesWordsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'examplesWords',
              lower: [examplesWordsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'examplesWords',
              lower: [],
              upper: [examplesWordsElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementGreaterThan(
    String examplesWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'examplesWords',
        lower: [examplesWordsElement],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementLessThan(
    String examplesWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'examplesWords',
        lower: [],
        upper: [examplesWordsElement],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementBetween(
    String lowerExamplesWordsElement,
    String upperExamplesWordsElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'examplesWords',
        lower: [lowerExamplesWordsElement],
        includeLower: includeLower,
        upper: [upperExamplesWordsElement],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementStartsWith(String ExamplesWordsElementPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'examplesWords',
        lower: [ExamplesWordsElementPrefix],
        upper: ['$ExamplesWordsElementPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'examplesWords',
        value: [''],
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterWhereClause>
      examplesWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'examplesWords',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'examplesWords',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'examplesWords',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'examplesWords',
              upper: [''],
            ));
      }
    });
  }
}

extension CardIsarQueryFilter
    on QueryBuilder<CardIsar, CardIsar, QFilterCondition> {
  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'examplesWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'examplesWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'examplesWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'examplesWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'examplesWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'examplesWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'examplesWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'examplesWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'examplesWords',
        value: '',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'examplesWords',
        value: '',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examplesWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examplesWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examplesWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examplesWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examplesWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      examplesWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examplesWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> fullCardTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullCardText',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      fullCardTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fullCardText',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> fullCardTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullCardText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      fullCardTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullCardText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> fullCardTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullCardText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> fullCardTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullCardText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      fullCardTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullCardText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> fullCardTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullCardText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> fullCardTextContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullCardText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> fullCardTextMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullCardText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      fullCardTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullCardText',
        value: '',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition>
      fullCardTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullCardText',
        value: '',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'headword',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'headword',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'headword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'headword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'headword',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'headword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'headword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'headword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'headword',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headword',
        value: '',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> headwordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'headword',
        value: '',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CardIsar, CardIsar, QAfterFilterCondition> idBetween(
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
}

extension CardIsarQueryObject
    on QueryBuilder<CardIsar, CardIsar, QFilterCondition> {}

extension CardIsarQueryLinks
    on QueryBuilder<CardIsar, CardIsar, QFilterCondition> {}

extension CardIsarQuerySortBy on QueryBuilder<CardIsar, CardIsar, QSortBy> {
  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> sortByFullCardText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.asc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> sortByFullCardTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.desc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> sortByHeadword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.asc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> sortByHeadwordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.desc);
    });
  }
}

extension CardIsarQuerySortThenBy
    on QueryBuilder<CardIsar, CardIsar, QSortThenBy> {
  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> thenByFullCardText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.asc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> thenByFullCardTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.desc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> thenByHeadword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.asc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> thenByHeadwordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.desc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension CardIsarQueryWhereDistinct
    on QueryBuilder<CardIsar, CardIsar, QDistinct> {
  QueryBuilder<CardIsar, CardIsar, QDistinct> distinctByExamplesWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'examplesWords');
    });
  }

  QueryBuilder<CardIsar, CardIsar, QDistinct> distinctByFullCardText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullCardText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardIsar, CardIsar, QDistinct> distinctByHeadword(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headword', caseSensitive: caseSensitive);
    });
  }
}

extension CardIsarQueryProperty
    on QueryBuilder<CardIsar, CardIsar, QQueryProperty> {
  QueryBuilder<CardIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CardIsar, List<String>, QQueryOperations>
      examplesWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'examplesWords');
    });
  }

  QueryBuilder<CardIsar, String?, QQueryOperations> fullCardTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullCardText');
    });
  }

  QueryBuilder<CardIsar, String?, QQueryOperations> headwordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headword');
    });
  }
}
