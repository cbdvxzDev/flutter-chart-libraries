import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced11LineErrorBars extends StatelessWidget {
  const Advanced11LineErrorBars({super.key});

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

    return Scaffold(
      appBar: AppBar(title: const Text('11. Barras de error en los puntos')),
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
                lineBarsData: [
                  LineChartBarData(
                    errorIndicatorData:
                        FlErrorIndicatorData<
                            LineChartSpotErrorRangeCallbackInput>(
                      painter: (input) => FlSimpleErrorPainter(
                        lineColor: Colors.indigo,
                        lineWidth: 2,
                        capLength: 10,
                      ),
                    ),
                    spots: const [
                      FlSpot(0, 45, yError: FlErrorRange(lowerBy: 6, upperBy: 9)),
                      FlSpot(1, 58, yError: FlErrorRange(lowerBy: 8, upperBy: 5)),
                      FlSpot(2, 50, yError: FlErrorRange(lowerBy: 5, upperBy: 7)),
                      FlSpot(3, 70, yError: FlErrorRange(lowerBy: 7, upperBy: 10)),
                      FlSpot(4, 64, yError: FlErrorRange(lowerBy: 9, upperBy: 6)),
                      FlSpot(5, 78, yError: FlErrorRange(lowerBy: 6, upperBy: 8)),
                    ],
                    color: Colors.indigo,
                    barWidth: 3,
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
