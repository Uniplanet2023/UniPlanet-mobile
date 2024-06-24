import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/account/widgets/pie_chart_data.dart';
import 'package:uniplanet/models/advertiser.dart';

class Chart extends StatelessWidget {
  final Advertiser advertiser;
  const Chart({super.key, required this.advertiser});

  @override
  Widget build(BuildContext context) {
    final pieChartData = ChartData(
      credit: advertiser.credit,
      freeCredit: advertiser.freeCredit,
      freeCreditUsed: advertiser.freeCreditUsed,
      creditUsed: advertiser.creditUsed,
    );

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: pieChartData.pieChartSelectionDatas,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  "${(advertiser.credit + advertiser.freeCredit - advertiser.freeCreditUsed - advertiser.creditUsed).toStringAsFixed(2)}\$",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                const SizedBox(height: 8),
                Text("of ${advertiser.freeCredit + advertiser.credit}\$ Credit",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
