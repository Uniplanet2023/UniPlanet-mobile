import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uniplanet/features/account/domain/entities/ad_stat_entity.dart';
import 'package:uniplanet/models/click_count.dart';

class AdStatModel {
  int today;
  int thisWeek;
  int thisMonth;
  int thisYear;
  List<ClickData> recent7Days;

  AdStatModel({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
    required this.recent7Days,
  });

  // Convert from domain model to data model
  factory AdStatModel.fromDomain(AdStatEntity adStatEntity) {
    return AdStatModel(
      today: adStatEntity.today,
      thisWeek: adStatEntity.thisWeek,
      thisMonth: adStatEntity.thisMonth,
      thisYear: adStatEntity.thisYear,
      recent7Days: adStatEntity.recent7Days,
    );
  }

  // Convert from data model to domain model
  AdStatEntity toDomain() {
    return AdStatEntity(
      today: today,
      thisWeek: thisWeek,
      thisMonth: thisMonth,
      thisYear: thisYear,
      recent7Days: recent7Days,
    );
  }

  static initialAdStat() {
    return AdStatModel(
      today: 0,
      thisWeek: 0,
      thisMonth: 0,
      thisYear: 0,
      recent7Days: List.generate(
          7,
          (index) => {
                'date': DateFormat('yyyy-MM-dd')
                    .format(DateTime.now().subtract(Duration(days: index))),
                'clickCount': 0,
              }).map((e) => ClickData.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'today': today,
      'thisWeek': thisWeek,
      'thisMonth': thisMonth,
      'thisYear': thisYear,
      'recent7Days': recent7Days,
    };
  }

  factory AdStatModel.fromMap(Map<String, dynamic> map) {
    return AdStatModel(
      today: map['today'] as int,
      thisWeek: map['thisWeek'] as int,
      thisMonth: map['thisMonth'] as int,
      thisYear: map['thisYear'] as int,
      recent7Days: List<ClickData>.from(
        (map['recent7Days'] as List<dynamic>).map<ClickData>(
          (item) => ClickData.fromMap(item as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory AdStatModel.fromJson(String source) =>
      AdStatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
