import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic18BarStacked extends StatelessWidget {
  const Basic18BarStacked({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
    const List<double> tienda = [30, 34, 32, 38];
    const List<double> redes = [18, 24, 27, 33];
    const List<double> retail = [22, 20, 26, 24];

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
      appBar: AppBar(title: const Text('18. Barras apiladas')),
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
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 20),
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
                      barRods: [
                        BarChartRodData(
                          toY: tienda[i] + redes[i] + retail[i],
                          width: 24,
                          rodStackItems: [
                            BarChartRodStackItem(0, tienda[i], Colors.indigo),
                            BarChartRodStackItem(
                              tienda[i],
                              tienda[i] + redes[i],
                              Colors.teal,
                            ),
                            BarChartRodStackItem(
                              tienda[i] + redes[i],
                              tienda[i] + redes[i] + retail[i],
                              Colors.orange.shade400,
                            ),
                          ],
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
