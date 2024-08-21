// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccountIsarModelCollection on Isar {
  IsarCollection<AccountIsarModel> get accountIsarModels => this.collection();
}

const AccountIsarModelSchema = CollectionSchema(
  name: r'AccountIsarModel',
  id: 4233750515714439752,
  properties: {
    r'isBlocked': PropertySchema(
      id: 0,
      name: r'isBlocked',
      type: IsarType.bool,
    ),
    r'isBlockedChat': PropertySchema(
      id: 1,
      name: r'isBlockedChat',
      type: IsarType.bool,
    ),
    r'isBlockedPost': PropertySchema(
      id: 2,
      name: r'isBlockedPost',
      type: IsarType.bool,
    ),
    r'type': PropertySchema(
      id: 3,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _accountIsarModelEstimateSize,
  serialize: _accountIsarModelSerialize,
  deserialize: _accountIsarModelDeserialize,
  deserializeProp: _accountIsarModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {
    r'userLink': LinkSchema(
      id: -1401981703414113188,
      name: r'userLink',
      target: r'UserIsarModel',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _accountIsarModelGetId,
  getLinks: _accountIsarModelGetLinks,
  attach: _accountIsarModelAttach,
  version: '3.1.0+1',
);

int _accountIsarModelEstimateSize(
  AccountIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _accountIsarModelSerialize(
  AccountIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isBlocked);
  writer.writeBool(offsets[1], object.isBlockedChat);
  writer.writeBool(offsets[2], object.isBlockedPost);
  writer.writeString(offsets[3], object.type);
}

AccountIsarModel _accountIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AccountIsarModel(
    isBlocked: reader.readBool(offsets[0]),
    isBlockedChat: reader.readBool(offsets[1]),
    isBlockedPost: reader.readBool(offsets[2]),
    type: reader.readString(offsets[3]),
  );
  object.isarId = id;
  return object;
}

P _accountIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _accountIsarModelGetId(AccountIsarModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _accountIsarModelGetLinks(AccountIsarModel object) {
  return [object.userLink];
}

void _accountIsarModelAttach(
    IsarCollection<dynamic> col, Id id, AccountIsarModel object) {
  object.isarId = id;
  object.userLink
      .attach(col, col.isar.collection<UserIsarModel>(), r'userLink', id);
}

extension AccountIsarModelQueryWhereSort
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QWhere> {
  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AccountIsarModelQueryWhere
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QWhereClause> {
  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AccountIsarModelQueryFilter
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QFilterCondition> {
  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      isBlockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBlocked',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      isBlockedChatEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBlockedChat',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      isBlockedPostEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBlockedPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension AccountIsarModelQueryObject
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QFilterCondition> {}

extension AccountIsarModelQueryLinks
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QFilterCondition> {
  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      userLink(FilterQuery<UserIsarModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'userLink');
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterFilterCondition>
      userLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'userLink', 0, true, 0, true);
    });
  }
}

extension AccountIsarModelQuerySortBy
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QSortBy> {
  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      sortByIsBlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      sortByIsBlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.desc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      sortByIsBlockedChat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      sortByIsBlockedChatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.desc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      sortByIsBlockedPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      sortByIsBlockedPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.desc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AccountIsarModelQuerySortThenBy
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QSortThenBy> {
  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsBlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsBlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.desc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsBlockedChat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsBlockedChatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.desc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsBlockedPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsBlockedPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.desc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AccountIsarModelQueryWhereDistinct
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QDistinct> {
  QueryBuilder<AccountIsarModel, AccountIsarModel, QDistinct>
      distinctByIsBlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBlocked');
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QDistinct>
      distinctByIsBlockedChat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBlockedChat');
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QDistinct>
      distinctByIsBlockedPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBlockedPost');
    });
  }

  QueryBuilder<AccountIsarModel, AccountIsarModel, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension AccountIsarModelQueryProperty
    on QueryBuilder<AccountIsarModel, AccountIsarModel, QQueryProperty> {
  QueryBuilder<AccountIsarModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AccountIsarModel, bool, QQueryOperations> isBlockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBlocked');
    });
  }

  QueryBuilder<AccountIsarModel, bool, QQueryOperations>
      isBlockedChatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBlockedChat');
    });
  }

  QueryBuilder<AccountIsarModel, bool, QQueryOperations>
      isBlockedPostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBlockedPost');
    });
  }

  QueryBuilder<AccountIsarModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
