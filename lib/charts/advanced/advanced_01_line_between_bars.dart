import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced01LineBetweenBars extends StatelessWidget {
  const Advanced01LineBetweenBars({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    const List<double> ventas2024 = [42, 55, 48, 62, 57, 71];
    const List<double> ventas2025 = [54, 61, 58, 73, 68, 86];

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
      appBar: AppBar(title: const Text('01. Área entre dos series')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: labels.length - 1,
                minY: 0,
                maxY: 100,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                betweenBarsData: [
                  BetweenBarsData(
                    fromIndex: 0,
                    toIndex: 1,
                    color: Colors.indigo.withValues(alpha: 0.18),
                  ),
                ],
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
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < labels.length; i++)
                        FlSpot(i.toDouble(), ventas2024[i]),
                    ],
                    color: Colors.indigo,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < labels.length; i++)
                        FlSpot(i.toDouble(), ventas2025[i]),
                    ],
                    color: Colors.teal,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
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
