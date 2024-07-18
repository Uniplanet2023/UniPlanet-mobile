import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartData {
  final List<PieChartSectionData> pieChartSelectionDatas;
  final double credit;
  final double freeCredit;
  final double freeCreditUsed;
  final double creditUsed;

  // Constructor with initializer list
  ChartData(
      {required this.credit,
      required this.freeCredit,
      required this.freeCreditUsed,
      required this.creditUsed})
      : pieChartSelectionDatas = [
          // Section representing the creditUsed amount
          PieChartSectionData(
            color: Colors.blueAccent,
            value: freeCreditUsed + creditUsed,
            showTitle: false,
            radius: 25,
          ),
          // Section representing the remaining budget + myCredit
          PieChartSectionData(
            color: Colors.blueAccent.withOpacity(0.2),
            value: (credit + freeCredit - freeCreditUsed - creditUsed)
                .clamp(0, double.infinity), // Ensure non-negative values
            showTitle: false,
            radius: 13,
          ),
        ];
}
