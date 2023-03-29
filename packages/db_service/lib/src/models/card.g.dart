// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCardCollection on Isar {
  IsarCollection<Card> get cards => this.collection();
}

const CardSchema = CollectionSchema(
  name: r'Card',
  id: 2706062385186124215,
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
  estimateSize: _cardEstimateSize,
  serialize: _cardSerialize,
  deserialize: _cardDeserialize,
  deserializeProp: _cardDeserializeProp,
  idName: r'id',
  indexes: {
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
  getId: _cardGetId,
  getLinks: _cardGetLinks,
  attach: _cardAttach,
  version: '3.0.5',
);

int _cardEstimateSize(
  Card object,
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

void _cardSerialize(
  Card object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.examplesWords);
  writer.writeString(offsets[1], object.fullCardText);
  writer.writeString(offsets[2], object.headword);
}

Card _cardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Card();
  object.fullCardText = reader.readStringOrNull(offsets[1]);
  object.headword = reader.readStringOrNull(offsets[2]);
  object.id = id;
  return object;
}

P _cardDeserializeProp<P>(
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

Id _cardGetId(Card object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _cardGetLinks(Card object) {
  return [];
}

void _cardAttach(IsarCollection<dynamic> col, Id id, Card object) {
  object.id = id;
}

extension CardQueryWhereSort on QueryBuilder<Card, Card, QWhere> {
  QueryBuilder<Card, Card, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Card, Card, QAfterWhere> anyExamplesWordsElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'examplesWords'),
      );
    });
  }
}

extension CardQueryWhere on QueryBuilder<Card, Card, QWhereClause> {
  QueryBuilder<Card, Card, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Card, Card, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Card, Card, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Card, Card, QAfterWhereClause> idBetween(
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

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementEqualTo(
      String examplesWordsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'examplesWords',
        value: [examplesWordsElement],
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementNotEqualTo(
      String examplesWordsElement) {
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

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementGreaterThan(
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

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementLessThan(
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

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementBetween(
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

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementStartsWith(
      String ExamplesWordsElementPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'examplesWords',
        lower: [ExamplesWordsElementPrefix],
        upper: ['$ExamplesWordsElementPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'examplesWords',
        value: [''],
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterWhereClause> examplesWordsElementIsNotEmpty() {
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

extension CardQueryFilter on QueryBuilder<Card, Card, QFilterCondition> {
  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsElementEqualTo(
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

  QueryBuilder<Card, Card, QAfterFilterCondition>
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsElementLessThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsElementBetween(
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

  QueryBuilder<Card, Card, QAfterFilterCondition>
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsElementEndsWith(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'examplesWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'examplesWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition>
      examplesWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'examplesWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition>
      examplesWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'examplesWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsLengthEqualTo(
      int length) {
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsIsEmpty() {
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsIsNotEmpty() {
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsLengthLessThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition>
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

  QueryBuilder<Card, Card, QAfterFilterCondition> examplesWordsLengthBetween(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullCardText',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fullCardText',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextEqualTo(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextGreaterThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextLessThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextBetween(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextStartsWith(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextEndsWith(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextContains(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextMatches(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullCardText',
        value: '',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> fullCardTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullCardText',
        value: '',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'headword',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'headword',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordEqualTo(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordGreaterThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordLessThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordBetween(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordStartsWith(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordEndsWith(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'headword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordMatches(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headword',
        value: '',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> headwordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'headword',
        value: '',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Card, Card, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Card, Card, QAfterFilterCondition> idBetween(
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

extension CardQueryObject on QueryBuilder<Card, Card, QFilterCondition> {}

extension CardQueryLinks on QueryBuilder<Card, Card, QFilterCondition> {}

extension CardQuerySortBy on QueryBuilder<Card, Card, QSortBy> {
  QueryBuilder<Card, Card, QAfterSortBy> sortByFullCardText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.asc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> sortByFullCardTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.desc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> sortByHeadword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.asc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> sortByHeadwordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.desc);
    });
  }
}

extension CardQuerySortThenBy on QueryBuilder<Card, Card, QSortThenBy> {
  QueryBuilder<Card, Card, QAfterSortBy> thenByFullCardText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.asc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> thenByFullCardTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullCardText', Sort.desc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> thenByHeadword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.asc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> thenByHeadwordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headword', Sort.desc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Card, Card, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension CardQueryWhereDistinct on QueryBuilder<Card, Card, QDistinct> {
  QueryBuilder<Card, Card, QDistinct> distinctByExamplesWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'examplesWords');
    });
  }

  QueryBuilder<Card, Card, QDistinct> distinctByFullCardText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullCardText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Card, Card, QDistinct> distinctByHeadword(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headword', caseSensitive: caseSensitive);
    });
  }
}

extension CardQueryProperty on QueryBuilder<Card, Card, QQueryProperty> {
  QueryBuilder<Card, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Card, List<String>, QQueryOperations> examplesWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'examplesWords');
    });
  }

  QueryBuilder<Card, String?, QQueryOperations> fullCardTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullCardText');
    });
  }

  QueryBuilder<Card, String?, QQueryOperations> headwordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headword');
    });
  }
}
