import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced17BarNegative extends StatelessWidget {
  const Advanced17BarNegative({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(labels[value.toInt()], style: const TextStyle(fontSize: 11)),
      );
    }

    Widget leftTitle(double value, TitleMeta meta) {
      if (value % 20 != 0) return const SizedBox.shrink();
      return Text(
        value.toInt().toString(),
        style: const TextStyle(fontSize: 11),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('17. Barras con valores negativos')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                minY: -60,
                maxY: 60,
                baselineY: 0,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
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
                      reservedSize: 40,
                      interval: 20,
                      getTitlesWidget: leftTitle,
                    ),
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
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: 40,
                        width: 20,
                        color: Colors.green.shade600,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        fromY: -35,
                        toY: 0,
                        width: 20,
                        color: Colors.red.shade600,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: 25,
                        width: 20,
                        color: Colors.green.shade600,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        fromY: -50,
                        toY: 0,
                        width: 20,
                        color: Colors.red.shade600,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: 55,
                        width: 20,
                        color: Colors.green.shade600,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 5,
                    barRods: [
                      BarChartRodData(
                        fromY: -20,
                        toY: 0,
                        width: 20,
                        color: Colors.red.shade600,
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
