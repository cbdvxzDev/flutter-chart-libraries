import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced22BarAnimated extends StatefulWidget {
  const Advanced22BarAnimated({super.key});

  @override
  State<Advanced22BarAnimated> createState() => _Advanced22BarAnimatedState();
}

class _Advanced22BarAnimatedState extends State<Advanced22BarAnimated> {
  static const labels = ['P1', 'P2', 'P3', 'P4', 'P5', 'P6'];
  static const List<double> semester1 = [37, 64, 49, 72, 58, 81];
  static const List<double> semester2 = [68, 44, 90, 53, 77, 62];

  bool _secondHalf = false;

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= labels.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(labels[value.toInt()], style: const TextStyle(fontSize: 11)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final values = _secondHalf ? semester2 : semester1;

    return Scaffold(
      appBar: AppBar(title: const Text('22. Barras con animación de datos')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
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
                          barRods: [
                            BarChartRodData(
                              toY: values[i],
                              width: 20,
                              color: Colors.amber.shade700,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    setState(() => _secondHalf = !_secondHalf),
                icon: const Icon(Icons.swap_horiz),
                label: Text(
                  _secondHalf ? 'Ver primer semestre' : 'Ver segundo semestre',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
