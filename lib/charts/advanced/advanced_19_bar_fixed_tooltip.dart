import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced19BarFixedTooltip extends StatelessWidget {
  const Advanced19BarFixedTooltip({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    const List<double> values = [42, 55, 48, 62, 57, 71];

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
      appBar: AppBar(title: const Text('19. Tooltip manual fijo en barra')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
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
                barTouchData: const BarTouchData(handleBuiltInTouches: false),
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
                barGroups: [
                  for (var i = 0; i < values.length; i++)
                    BarChartGroupData(
                      x: i,
                      showingTooltipIndicators: i == 3 ? [0] : const [],
                      barRods: [
                        BarChartRodData(
                          toY: values[i],
                          width: 18,
                          color: i == 3
                              ? Colors.deepOrange
                              : Colors.indigo.withValues(alpha: 0.6),
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
