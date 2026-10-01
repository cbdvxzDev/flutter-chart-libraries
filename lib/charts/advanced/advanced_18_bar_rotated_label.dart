import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced18BarRotatedLabel extends StatelessWidget {
  const Advanced18BarRotatedLabel({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Acc. Norte', 'Acc. Sur', 'Acc. Centro', 'Acc. Oeste'];
    const List<double> rodValues = [82, 47, 96, 63];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(
          labels[value.toInt()],
          style: const TextStyle(fontSize: 10),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('18. Etiqueta rotada en la barra')),
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
                      reservedSize: 40,
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
                          toY: rodValues[i],
                          width: 30,
                          color: Colors.indigo,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                          label: BarChartRodLabel(
                            show: true,
                            text: '${rodValues[i].toInt()} u.',
                            angle: -70,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
