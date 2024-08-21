import 'dart:convert';
import 'package:uniplanet/features/account/domain/entities/account.dart';

class Advertiser {
  AccountEntity account;
  int maximumPost;
  int numberOfPost;
  double costPerClick;
  double freeCreditUsed;
  double freeCredit;
  double credit;
  double creditUsed;

  Advertiser({
    required this.account,
    this.maximumPost = 0,
    this.numberOfPost = 0,
    this.costPerClick = 0.4,
    this.freeCreditUsed = 0,
    this.freeCredit = 0,
    this.credit = 0,
    this.creditUsed = 0,
  });

  static initialAdtertiser() {
    return Advertiser(
      account: AccountEntity.initialAccount(),
      maximumPost: 0,
      numberOfPost: 0,
      costPerClick: 0.4,
      freeCreditUsed: 0,
      freeCredit: 0,
      credit: 0,
      creditUsed: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account': account.toMap(),
      'maximumPost': maximumPost,
      'numberOfPost': numberOfPost,
      'costPerClick': costPerClick,
      'freeCreditUsed': freeCreditUsed,
      'freeCredit': freeCredit,
      'credit': credit,
      'creditUsed': creditUsed,
    };
  }

  factory Advertiser.fromMap(Map<String, dynamic> map) {
    return Advertiser(
      account: AccountEntity.fromMap(map),
      maximumPost: map['maximumPost'] as int,
      numberOfPost: map['numberOfPost'] as int,
      costPerClick: (map['costPerClick'] as num).toDouble(),
      freeCreditUsed: (map['freeCreditUsed'] as num).toDouble(),
      freeCredit: (map['freeCredit'] as num).toDouble(),
      credit: (map['credit'] as num).toDouble(),
      creditUsed: (map['creditUsed'] as num).toDouble(),
    );
  }

  factory Advertiser.fromJson(String source) =>
      Advertiser.fromMap(json.decode(source) as Map<String, dynamic>);
}
