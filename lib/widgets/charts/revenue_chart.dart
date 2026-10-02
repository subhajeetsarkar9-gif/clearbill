import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  if (value.toInt() >= 0 && value.toInt() < months.length) {
                    return Text(months[value.toInt()], style: const TextStyle(fontSize: 12));
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: AppColors.primary)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12, color: AppColors.primary)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: AppColors.primary)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 20, color: AppColors.primary)]),
            BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 18, color: AppColors.primary)]),
            BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 25, color: AppColors.primary)]),
          ],
        ),
      ),
    );
  }
}
