import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic15LineAxisTitles extends StatelessWidget {
  const Basic15LineAxisTitles({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    const List<double> values = [1800.0, 2100, 1950, 2400, 2250, 2700];

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
      appBar: AppBar(title: const Text('15. Ejes con intervalo y nombre')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: labels.length - 1,
                minY: 1500,
                maxY: 3000,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(
                    axisNameWidget: Text(
                      'Unidades',
                      style: TextStyle(fontSize: 12),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 52,
                      interval: 500,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(
                      'Mes',
                      style: TextStyle(fontSize: 12),
                    ),
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
                    color: Colors.indigo,
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
