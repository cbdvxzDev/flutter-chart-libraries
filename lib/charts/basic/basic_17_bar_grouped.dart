import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic17BarGrouped extends StatelessWidget {
  const Basic17BarGrouped({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
    const List<double> presencial = [38, 45, 52, 61];
    const List<double> online = [25, 34, 41, 55];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(labels[value.toInt()], style: const TextStyle(fontSize: 12)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('17. Barras agrupadas')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: 70,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 10),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: bottomTitle,
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < labels.length; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: 8,
                      barRods: [
                        BarChartRodData(
                          toY: presencial[i],
                          color: Colors.indigo,
                          width: 12,
                        ),
                        BarChartRodData(
                          toY: online[i],
                          color: Colors.teal,
                          width: 12,
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
