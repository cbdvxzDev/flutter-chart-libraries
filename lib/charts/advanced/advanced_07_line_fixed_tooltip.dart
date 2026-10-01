import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced07LineFixedTooltip extends StatelessWidget {
  const Advanced07LineFixedTooltip({super.key});

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

    final bar = LineChartBarData(
      spots: [
        for (var i = 0; i < labels.length; i++)
          FlSpot(i.toDouble(), values[i]),
      ],
      color: Colors.indigo,
      barWidth: 3,
      dotData: const FlDotData(show: true),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('07. Tooltip fijo sin tocar')),
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
                showingTooltipIndicators: [
                  ShowingTooltipIndicators([
                    LineBarSpot(bar, 0, bar.spots[3]),
                  ]),
                ],
                lineTouchData: const LineTouchData(enabled: false),
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
                lineBarsData: [bar],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
