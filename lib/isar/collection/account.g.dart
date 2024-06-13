// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccountModelCollection on Isar {
  IsarCollection<AccountModel> get accountModels => this.collection();
}

const AccountModelSchema = CollectionSchema(
  name: r'AccountModel',
  id: -4417758972305866022,
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
    r'maximumClick': PropertySchema(
      id: 3,
      name: r'maximumClick',
      type: IsarType.long,
    ),
    r'maximumPost': PropertySchema(
      id: 4,
      name: r'maximumPost',
      type: IsarType.long,
    ),
    r'numberOfClick': PropertySchema(
      id: 5,
      name: r'numberOfClick',
      type: IsarType.long,
    ),
    r'numberOfPost': PropertySchema(
      id: 6,
      name: r'numberOfPost',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 7,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _accountModelEstimateSize,
  serialize: _accountModelSerialize,
  deserialize: _accountModelDeserialize,
  deserializeProp: _accountModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {
    r'user': LinkSchema(
      id: 6480756853110184183,
      name: r'user',
      target: r'UserModel',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _accountModelGetId,
  getLinks: _accountModelGetLinks,
  attach: _accountModelAttach,
  version: '3.1.0+1',
);

int _accountModelEstimateSize(
  AccountModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _accountModelSerialize(
  AccountModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isBlocked);
  writer.writeBool(offsets[1], object.isBlockedChat);
  writer.writeBool(offsets[2], object.isBlockedPost);
  writer.writeLong(offsets[3], object.maximumClick);
  writer.writeLong(offsets[4], object.maximumPost);
  writer.writeLong(offsets[5], object.numberOfClick);
  writer.writeLong(offsets[6], object.numberOfPost);
  writer.writeString(offsets[7], object.type);
}

AccountModel _accountModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AccountModel(
    isBlocked: reader.readBool(offsets[0]),
    isBlockedChat: reader.readBool(offsets[1]),
    isBlockedPost: reader.readBool(offsets[2]),
    maximumClick: reader.readLongOrNull(offsets[3]),
    maximumPost: reader.readLongOrNull(offsets[4]),
    numberOfClick: reader.readLong(offsets[5]),
    numberOfPost: reader.readLong(offsets[6]),
    type: reader.readString(offsets[7]),
  );
  object.isarId = id;
  return object;
}

P _accountModelDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _accountModelGetId(AccountModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _accountModelGetLinks(AccountModel object) {
  return [object.user];
}

void _accountModelAttach(
    IsarCollection<dynamic> col, Id id, AccountModel object) {
  object.isarId = id;
  object.user.attach(col, col.isar.collection<UserModel>(), r'user', id);
}

extension AccountModelQueryWhereSort
    on QueryBuilder<AccountModel, AccountModel, QWhere> {
  QueryBuilder<AccountModel, AccountModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AccountModelQueryWhere
    on QueryBuilder<AccountModel, AccountModel, QWhereClause> {
  QueryBuilder<AccountModel, AccountModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<AccountModel, AccountModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterWhereClause> isarIdBetween(
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

extension AccountModelQueryFilter
    on QueryBuilder<AccountModel, AccountModel, QFilterCondition> {
  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      isBlockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBlocked',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      isBlockedChatEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBlockedChat',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      isBlockedPostEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBlockedPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumClickIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maximumClick',
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumClickIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maximumClick',
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumClickEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maximumClick',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumClickGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maximumClick',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumClickLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maximumClick',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumClickBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maximumClick',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumPostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maximumPost',
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumPostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maximumPost',
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumPostEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maximumPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumPostGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maximumPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumPostLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maximumPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      maximumPostBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maximumPost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfClickEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfClick',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfClickGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfClick',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfClickLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfClick',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfClickBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfClick',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfPostEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfPostGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfPostLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfPost',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      numberOfPostBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfPost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension AccountModelQueryObject
    on QueryBuilder<AccountModel, AccountModel, QFilterCondition> {}

extension AccountModelQueryLinks
    on QueryBuilder<AccountModel, AccountModel, QFilterCondition> {
  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> user(
      FilterQuery<UserModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'user');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterFilterCondition> userIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'user', 0, true, 0, true);
    });
  }
}

extension AccountModelQuerySortBy
    on QueryBuilder<AccountModel, AccountModel, QSortBy> {
  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByIsBlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByIsBlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByIsBlockedChat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      sortByIsBlockedChatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByIsBlockedPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      sortByIsBlockedPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByMaximumClick() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumClick', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      sortByMaximumClickDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumClick', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByMaximumPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPost', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      sortByMaximumPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPost', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByNumberOfClick() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfClick', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      sortByNumberOfClickDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfClick', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByNumberOfPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfPost', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      sortByNumberOfPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfPost', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AccountModelQuerySortThenBy
    on QueryBuilder<AccountModel, AccountModel, QSortThenBy> {
  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByIsBlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByIsBlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlocked', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByIsBlockedChat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      thenByIsBlockedChatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedChat', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByIsBlockedPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      thenByIsBlockedPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBlockedPost', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByMaximumClick() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumClick', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      thenByMaximumClickDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumClick', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByMaximumPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPost', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      thenByMaximumPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maximumPost', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByNumberOfClick() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfClick', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      thenByNumberOfClickDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfClick', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByNumberOfPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfPost', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy>
      thenByNumberOfPostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfPost', Sort.desc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<AccountModel, AccountModel, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension AccountModelQueryWhereDistinct
    on QueryBuilder<AccountModel, AccountModel, QDistinct> {
  QueryBuilder<AccountModel, AccountModel, QDistinct> distinctByIsBlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBlocked');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QDistinct>
      distinctByIsBlockedChat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBlockedChat');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QDistinct>
      distinctByIsBlockedPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBlockedPost');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QDistinct> distinctByMaximumClick() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maximumClick');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QDistinct> distinctByMaximumPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maximumPost');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QDistinct>
      distinctByNumberOfClick() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfClick');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QDistinct> distinctByNumberOfPost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfPost');
    });
  }

  QueryBuilder<AccountModel, AccountModel, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension AccountModelQueryProperty
    on QueryBuilder<AccountModel, AccountModel, QQueryProperty> {
  QueryBuilder<AccountModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AccountModel, bool, QQueryOperations> isBlockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBlocked');
    });
  }

  QueryBuilder<AccountModel, bool, QQueryOperations> isBlockedChatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBlockedChat');
    });
  }

  QueryBuilder<AccountModel, bool, QQueryOperations> isBlockedPostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBlockedPost');
    });
  }

  QueryBuilder<AccountModel, int?, QQueryOperations> maximumClickProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maximumClick');
    });
  }

  QueryBuilder<AccountModel, int?, QQueryOperations> maximumPostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maximumPost');
    });
  }

  QueryBuilder<AccountModel, int, QQueryOperations> numberOfClickProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfClick');
    });
  }

  QueryBuilder<AccountModel, int, QQueryOperations> numberOfPostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfPost');
    });
  }

  QueryBuilder<AccountModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
