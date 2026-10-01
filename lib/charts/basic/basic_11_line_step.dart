import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic11LineStep extends StatelessWidget {
  const Basic11LineStep({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['08:00', '10:00', '12:00', '14:00', '16:00', '18:00'];
    const List<double> values = [12.0, 18, 15, 24, 21, 30];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(
          labels[value.toInt()],
          style: const TextStyle(fontSize: 11),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('11. Línea de pasos (step)')),
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
                maxY: 35,
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
                      reservedSize: 34,
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
                    color: Colors.cyan.shade700,
                    barWidth: 3,
                    isStepLineChart: true,
                    lineChartStepData:
                        const LineChartStepData(stepDirection: 0.5),
                    dotData: const FlDotData(show: true),
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
