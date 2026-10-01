import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced21BarAxisWidgets extends StatelessWidget {
  const Advanced21BarAxisWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
    const List<double> values = [64, 88, 52, 96];
    const icons = [
      Icons.spa,
      Icons.wb_sunny,
      Icons.ac_unit,
      Icons.local_fire_department,
    ];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      final index = value.toInt();
      return SideTitleWidget(
        meta: meta,
        space: 6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icons[index], size: 16, color: Colors.indigo),
            Text(
              labels[index],
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      );
    }

    Widget leftTitle(double value, TitleMeta meta) {
      if (value % 30 != 0) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: value == 90
              ? Colors.deepOrange.withValues(alpha: 0.9)
              : Colors.indigo.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${value.toInt()}',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('21. Títulos de eje con widgets')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: 120,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 52,
                      interval: 30,
                      getTitlesWidget: leftTitle,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 46,
                      interval: 1,
                      getTitlesWidget: bottomTitle,
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < values.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i],
                          width: 24,
                          color: Colors.indigo,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
