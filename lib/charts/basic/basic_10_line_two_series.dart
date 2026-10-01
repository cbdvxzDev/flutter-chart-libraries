import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic10LineTwoSeries extends StatelessWidget {
  const Basic10LineTwoSeries({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    const List<double> ventas2024 = [42.0, 48, 45, 55, 52, 63];
    const List<double> ventas2025 = [52.0, 58, 54, 68, 65, 78];

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(labels[value.toInt()], style: const TextStyle(fontSize: 11)),
      );
    }

    Widget legendItem(Color color, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      );
    }

    LineChartBarData series(List<double> values, Color color) {
      return LineChartBarData(
        spots: [
          for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
        ],
        color: color,
        barWidth: 3,
        dotData: const FlDotData(show: false),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('10. Dos series de datos')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  legendItem(Colors.indigo, 'Ventas 2024'),
                  const SizedBox(width: 20),
                  legendItem(Colors.teal, 'Ventas 2025'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: labels.length - 1,
                    minY: 30,
                    maxY: 90,
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 10,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 10),
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
                      series(ventas2024, Colors.indigo),
                      series(ventas2025, Colors.teal),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
