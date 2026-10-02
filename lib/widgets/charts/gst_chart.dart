import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';

class GSTChart extends StatelessWidget {
  final double cgst;
  final double sgst;
  final double igst;

  const GSTChart({
    super.key,
    required this.cgst,
    required this.sgst,
    required this.igst,
  });

  @override
  Widget build(BuildContext context) {
    final double total = cgst + sgst + igst;
    if (total == 0) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('No GST data available for this period')),
      );
    }

    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              color: AppColors.primary,
              value: cgst > 0 ? cgst : 1,
              title: 'CGST',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              color: AppColors.primaryDark,
              value: sgst > 0 ? sgst : 1,
              title: 'SGST',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              color: AppColors.accent,
              value: igst > 0 ? igst : 1,
              title: 'IGST',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
