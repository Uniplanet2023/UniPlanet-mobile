import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartData {
  final List<PieChartSectionData> pieChartSelectionDatas;
  final double budget;
  final double givenCredit;
  final double usedCredit;
  final double spent;

  // Constructor with initializer list
  ChartData(
      {required this.budget,
      required this.givenCredit,
      required this.spent,
      required this.usedCredit})
      : pieChartSelectionDatas = [
          // Section representing the spent amount
          PieChartSectionData(
            color: Colors.blueAccent,
            value: spent + usedCredit,
            showTitle: false,
            radius: 25,
          ),
          // Section representing the remaining budget + myCredit
          PieChartSectionData(
            color: Colors.blueAccent.withOpacity(0.2),
            value: (budget + givenCredit - spent - usedCredit)
                .clamp(0, double.infinity), // Ensure non-negative values
            showTitle: false,
            radius: 13,
          ),
        ];
}
