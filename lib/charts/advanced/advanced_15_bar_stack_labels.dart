import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced15BarStackLabels extends StatelessWidget {
  const Advanced15BarStackLabels({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Web', 'App', 'Tienda'];

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
      appBar: AppBar(title: const Text('15. Apiladas con etiqueta por segmento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: 120,
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
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 100,
                        width: 34,
                        color: Colors.grey.shade300,
                        rodStackItems: [
                          BarChartRodStackItem(
                            0,
                            45,
                            Colors.indigo,
                            label: '45',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BarChartRodStackItem(
                            45,
                            75,
                            Colors.teal,
                            label: '30',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BarChartRodStackItem(
                            75,
                            100,
                            Colors.orange,
                            label: '25',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
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
