import 'dart:convert';
import 'package:uniplanet/models/account.dart';

class Advertiser {
  Account account;
  int maximumPost;
  int numberOfPost;
  double costPerClick;
  double usedCredit;
  double givenCredit;
  double budget;
  double spent;

  Advertiser({
    required this.account,
    this.maximumPost = 0,
    this.numberOfPost = 0,
    this.costPerClick = 0.4,
    this.usedCredit = 0,
    this.givenCredit = 0,
    this.budget = 0,
    this.spent = 0,
  });

  static initialAdtertiser() {
    return Advertiser(
      account: Account.initialAccount(),
      maximumPost: 0,
      numberOfPost: 0,
      costPerClick: 0.4,
      usedCredit: 0,
      givenCredit: 0,
      budget: 0,
      spent: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account': account.toMap(),
      'maximumPost': maximumPost,
      'numberOfPost': numberOfPost,
      'costPerClick': costPerClick,
      'usedCredit': usedCredit,
      'givenCredit': givenCredit,
      'budget': budget,
      'spent': spent,
    };
  }

  factory Advertiser.fromMap(Map<String, dynamic> map) {
    return Advertiser(
      account: Account.fromMap(map),
      maximumPost: map['maximumPost'] as int,
      numberOfPost: map['numberOfPost'] as int,
      costPerClick: (map['costPerClick'] as num).toDouble(),
      usedCredit: (map['usedCredit'] as num).toDouble(),
      givenCredit: (map['givenCredit'] as num).toDouble(),
      budget: (map['budget'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
    );
  }

  factory Advertiser.fromJson(String source) =>
      Advertiser.fromMap(json.decode(source) as Map<String, dynamic>);
}
