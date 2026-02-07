// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIngredientCollection on Isar {
  IsarCollection<Ingredient> get ingredients => this.collection();
}

const IngredientSchema = CollectionSchema(
  name: r'Ingredient',
  id: 800151778681338436,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'displayName': PropertySchema(
      id: 1,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'normalizedName': PropertySchema(
      id: 2,
      name: r'normalizedName',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'usageCount': PropertySchema(
      id: 4,
      name: r'usageCount',
      type: IsarType.long,
    )
  },
  estimateSize: _ingredientEstimateSize,
  serialize: _ingredientSerialize,
  deserialize: _ingredientDeserialize,
  deserializeProp: _ingredientDeserializeProp,
  idName: r'id',
  indexes: {
    r'normalizedName': IndexSchema(
      id: -9115371092206571671,
      name: r'normalizedName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'normalizedName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _ingredientGetId,
  getLinks: _ingredientGetLinks,
  attach: _ingredientAttach,
  version: '3.1.0+1',
);

int _ingredientEstimateSize(
  Ingredient object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.normalizedName.length * 3;
  return bytesCount;
}

void _ingredientSerialize(
  Ingredient object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.displayName);
  writer.writeString(offsets[2], object.normalizedName);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeLong(offsets[4], object.usageCount);
}

Ingredient _ingredientDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Ingredient();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.displayName = reader.readString(offsets[1]);
  object.id = id;
  object.normalizedName = reader.readString(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  object.usageCount = reader.readLong(offsets[4]);
  return object;
}

P _ingredientDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ingredientGetId(Ingredient object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ingredientGetLinks(Ingredient object) {
  return [];
}

void _ingredientAttach(IsarCollection<dynamic> col, Id id, Ingredient object) {
  object.id = id;
}

extension IngredientByIndex on IsarCollection<Ingredient> {
  Future<Ingredient?> getByNormalizedName(String normalizedName) {
    return getByIndex(r'normalizedName', [normalizedName]);
  }

  Ingredient? getByNormalizedNameSync(String normalizedName) {
    return getByIndexSync(r'normalizedName', [normalizedName]);
  }

  Future<bool> deleteByNormalizedName(String normalizedName) {
    return deleteByIndex(r'normalizedName', [normalizedName]);
  }

  bool deleteByNormalizedNameSync(String normalizedName) {
    return deleteByIndexSync(r'normalizedName', [normalizedName]);
  }

  Future<List<Ingredient?>> getAllByNormalizedName(
      List<String> normalizedNameValues) {
    final values = normalizedNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'normalizedName', values);
  }

  List<Ingredient?> getAllByNormalizedNameSync(
      List<String> normalizedNameValues) {
    final values = normalizedNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'normalizedName', values);
  }

  Future<int> deleteAllByNormalizedName(List<String> normalizedNameValues) {
    final values = normalizedNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'normalizedName', values);
  }

  int deleteAllByNormalizedNameSync(List<String> normalizedNameValues) {
    final values = normalizedNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'normalizedName', values);
  }

  Future<Id> putByNormalizedName(Ingredient object) {
    return putByIndex(r'normalizedName', object);
  }

  Id putByNormalizedNameSync(Ingredient object, {bool saveLinks = true}) {
    return putByIndexSync(r'normalizedName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNormalizedName(List<Ingredient> objects) {
    return putAllByIndex(r'normalizedName', objects);
  }

  List<Id> putAllByNormalizedNameSync(List<Ingredient> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'normalizedName', objects, saveLinks: saveLinks);
  }
}

extension IngredientQueryWhereSort
    on QueryBuilder<Ingredient, Ingredient, QWhere> {
  QueryBuilder<Ingredient, Ingredient, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IngredientQueryWhere
    on QueryBuilder<Ingredient, Ingredient, QWhereClause> {
  QueryBuilder<Ingredient, Ingredient, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Ingredient, Ingredient, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterWhereClause> idBetween(
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

  QueryBuilder<Ingredient, Ingredient, QAfterWhereClause> normalizedNameEqualTo(
      String normalizedName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'normalizedName',
        value: [normalizedName],
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterWhereClause>
      normalizedNameNotEqualTo(String normalizedName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalizedName',
              lower: [],
              upper: [normalizedName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalizedName',
              lower: [normalizedName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalizedName',
              lower: [normalizedName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'normalizedName',
              lower: [],
              upper: [normalizedName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IngredientQueryFilter
    on QueryBuilder<Ingredient, Ingredient, QFilterCondition> {
  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'normalizedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'normalizedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'normalizedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'normalizedName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'normalizedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'normalizedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'normalizedName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'normalizedName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'normalizedName',
        value: '',
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      normalizedNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'normalizedName',
        value: '',
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> usageCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'usageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      usageCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'usageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition>
      usageCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'usageCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterFilterCondition> usageCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'usageCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IngredientQueryObject
    on QueryBuilder<Ingredient, Ingredient, QFilterCondition> {}

extension IngredientQueryLinks
    on QueryBuilder<Ingredient, Ingredient, QFilterCondition> {}

extension IngredientQuerySortBy
    on QueryBuilder<Ingredient, Ingredient, QSortBy> {
  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByNormalizedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalizedName', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy>
      sortByNormalizedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalizedName', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByUsageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usageCount', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> sortByUsageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usageCount', Sort.desc);
    });
  }
}

extension IngredientQuerySortThenBy
    on QueryBuilder<Ingredient, Ingredient, QSortThenBy> {
  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByNormalizedName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalizedName', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy>
      thenByNormalizedNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalizedName', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByUsageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usageCount', Sort.asc);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QAfterSortBy> thenByUsageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usageCount', Sort.desc);
    });
  }
}

extension IngredientQueryWhereDistinct
    on QueryBuilder<Ingredient, Ingredient, QDistinct> {
  QueryBuilder<Ingredient, Ingredient, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Ingredient, Ingredient, QDistinct> distinctByDisplayName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QDistinct> distinctByNormalizedName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'normalizedName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Ingredient, Ingredient, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Ingredient, Ingredient, QDistinct> distinctByUsageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usageCount');
    });
  }
}

extension IngredientQueryProperty
    on QueryBuilder<Ingredient, Ingredient, QQueryProperty> {
  QueryBuilder<Ingredient, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Ingredient, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Ingredient, String, QQueryOperations> displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<Ingredient, String, QQueryOperations> normalizedNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'normalizedName');
    });
  }

  QueryBuilder<Ingredient, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Ingredient, int, QQueryOperations> usageCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usageCount');
    });
  }
}
