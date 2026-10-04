import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced14BarErrorRange extends StatelessWidget {
  const Advanced14BarErrorRange({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Álgebra', 'Cálculo', 'Física', 'Química', 'Historia'];
    const List<double> values = [77, 61, 90, 53, 68];

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
      appBar: AppBar(title: const Text('14. Barras con rango de error')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: 110,
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
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 20,
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
                errorIndicatorData:
                    FlErrorIndicatorData<BarChartSpotErrorRangeCallbackInput>(
                  painter: (input) => FlSimpleErrorPainter(
                    lineColor: Colors.deepOrange,
                    lineWidth: 2,
                    capLength: 10,
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < values.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i],
                          width: 18,
                          color: Colors.blueGrey,
                          toYErrorRange: FlErrorRange(
                            lowerBy: 5 + i.toDouble(),
                            upperBy: 12 - i.toDouble(),
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
