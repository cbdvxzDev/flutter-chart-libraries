import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic25BarDashedBorder extends StatelessWidget {
  const Basic25BarDashedBorder({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Recoger', 'Cargar', 'Trasladar', 'Descargar', 'Entregar'];
    const List<double> values = [48, 72, 60, 90, 55];
    const colors = [
      Colors.cyan,
      Colors.amber,
      Colors.pink,
      Colors.green,
      Colors.blueGrey,
    ];

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
      appBar: AppBar(title: const Text('25. Barras con borde punteado')),
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
                  for (var i = 0; i < values.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i],
                          color: colors[i].withValues(alpha: 0.25),
                          width: 22,
                          borderSide: BorderSide(
                            color: colors[i],
                            width: 2,
                          ),
                          borderDashArray: const [6, 4],
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
