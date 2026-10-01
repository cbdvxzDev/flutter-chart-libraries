import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic13LineRoundCaps extends StatelessWidget {
  const Basic13LineRoundCaps({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    const List<double> values = [28.0, 34, 31, 42, 39, 50];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(labels[value.toInt()], style: const TextStyle(fontSize: 11)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('13. Extremos redondeados')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: labels.length - 1,
                minY: 20,
                maxY: 55,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 5),
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
                      for (var i = 0; i < values.length; i++)
                        FlSpot(i.toDouble(), values[i]),
                    ],
                    color: Colors.teal.shade700,
                    barWidth: 6,
                    isStrokeCapRound: true,
                    isStrokeJoinRound: true,
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
