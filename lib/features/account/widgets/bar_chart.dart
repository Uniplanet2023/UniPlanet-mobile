import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/models/click_count.dart';

class IndividualBar {
  final int x;
  final int y; // Changed from double to int

  IndividualBar({required this.x, required this.y});
}

class BarData {
  final int sunAmount; // Changed from double to int
  final int monAmount; // Changed from double to int
  final int tueAmount; // Changed from double to int
  final int wedAmount; // Changed from double to int
  final int thuAmount; // Changed from double to int
  final int friAmount; // Changed from double to int
  final int satAmount; // Changed from double to int

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 1, y: tueAmount),
      IndividualBar(x: 2, y: wedAmount),
      IndividualBar(x: 3, y: thuAmount),
      IndividualBar(x: 4, y: friAmount),
      IndividualBar(x: 5, y: satAmount),
      IndividualBar(x: 6, y: sunAmount),
    ];
  }
}

class MyBarGraph extends StatelessWidget {
  final List<ClickData> weeklySummary; // Changed from List<double> to List<int>

  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    // Initialize bar data
    BarData barData = BarData(
      monAmount: weeklySummary[0].clickCount,
      tueAmount: weeklySummary[1].clickCount,
      wedAmount: weeklySummary[2].clickCount,
      thuAmount: weeklySummary[3].clickCount,
      friAmount: weeklySummary[4].clickCount,
      satAmount: weeklySummary[5].clickCount,
      sunAmount: weeklySummary[6].clickCount,
    );
    barData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: barData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y.toDouble(), // Convert int to double here
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    rodStackItems: [
                      BarChartRodStackItem(
                          0, data.y.toDouble(), Colors.transparent),
                    ],
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            )
            .toList(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(0),
            tooltipMargin: 0,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipBorder: const BorderSide(color: Colors.transparent),
            tooltipRoundedRadius: 0,
            getTooltipColor: (group) => Colors.transparent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.toInt().toString(), // Display as int
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {},
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  Widget text;

  switch (value.toInt()) {
    case 0:
      text = const Text('Mon', style: style);
      break;
    case 1:
      text = const Text('Tue', style: style);
      break;
    case 2:
      text = const Text('Wed', style: style);
      break;
    case 3:
      text = const Text('Thu', style: style);
      break;
    case 4:
      text = const Text('Fri', style: style);
      break;
    case 5:
      text = const Text('Sat', style: style);
      break;
    case 6:
      text = const Text('Sun', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
