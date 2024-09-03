import 'package:intl/intl.dart';
import 'package:uniplanet/models/click_count.dart';

class AdStatEntity {
  final int today;
  final int thisWeek;
  final int thisMonth;
  final int thisYear;
  final List<ClickData> recent7Days;

  const AdStatEntity({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
    required this.recent7Days,
  });

  // Initial ad stat entity with default values
  static AdStatEntity initialAdStat() {
    return AdStatEntity(
      today: 0,
      thisWeek: 0,
      thisMonth: 0,
      thisYear: 0,
      // TODO: find a way to move this to data layer, maybe by creating a Click data entity
      recent7Days: List.generate(
          7,
          (index) => {
                'date': DateFormat('yyyy-MM-dd')
                    .format(DateTime.now().subtract(Duration(days: index))),
                'clickCount': 0,
              }).map((e) => ClickData.fromMap(e)).toList(),
    );
  }
}
