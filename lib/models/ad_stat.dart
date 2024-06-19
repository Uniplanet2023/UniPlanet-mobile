import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uniplanet/models/click_count.dart';

class AdStat {
  int today;
  int thisWeek;
  int thisMonth;
  int thisYear;
  List<ClickData> recent7Days;

  AdStat({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
    required this.recent7Days,
  });

  static initialAdtertiser() {
    return AdStat(
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

  factory AdStat.fromMap(Map<String, dynamic> map) {
    return AdStat(
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

  factory AdStat.fromJson(String source) =>
      AdStat.fromMap(json.decode(source) as Map<String, dynamic>);
}
