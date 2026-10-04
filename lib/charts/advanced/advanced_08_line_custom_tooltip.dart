import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced08LineCustomTooltip extends StatelessWidget {
  const Advanced08LineCustomTooltip({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Cli1', 'Cli2', 'Cli3', 'Cli4', 'Cli5', 'Cli6'];
    const List<double> ingresos = [71, 64, 78, 69, 82, 76];
    const List<double> costos = [45, 51, 48, 57, 54, 61];

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
      appBar: AppBar(title: const Text('08. Tooltip enriquecido')),
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
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 160,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final esIngreso = spot.barIndex == 0;
                        final etiqueta = esIngreso ? 'Ingresos' : 'Costos';
                        final color =
                            esIngreso ? Colors.purple : Colors.deepOrange;
                        return LineTooltipItem(
                          '$etiqueta\n${labels[spot.x.toInt()]}: ${spot.y.toInt()} k',
                          TextStyle(
                            color: color,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        );
                      }).toList();
                    },
                  ),
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
                    spots: [
                      for (var i = 0; i < labels.length; i++)
                        FlSpot(i.toDouble(), ingresos[i]),
                    ],
                    color: Colors.purple,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < labels.length; i++)
                        FlSpot(i.toDouble(), costos[i]),
                    ],
                    color: Colors.deepOrange,
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
