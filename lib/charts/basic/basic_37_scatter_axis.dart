import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic37ScatterAxis extends StatelessWidget {
  const Basic37ScatterAxis({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 2020 || value > 2026 || value % 2 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    Widget leftTitle(double value, TitleMeta meta) {
      if (value % 10 != 0) return const SizedBox.shrink();
      return Text(
        '${value.toInt()}k',
        style: const TextStyle(fontSize: 12),
      );
    }

    final spots = [
      ScatterSpot(2020, 32),
      ScatterSpot(2021, 41),
      ScatterSpot(2022, 48),
      ScatterSpot(2023, 57),
      ScatterSpot(2024, 66),
      ScatterSpot(2025, 74),
      ScatterSpot(2026, 88),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('37. Dispersión con ejes personalizados')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: ScatterChart(
              ScatterChartData(
                minX: 2019,
                maxX: 2027,
                minY: 0,
                maxY: 100,
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
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: leftTitle,
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
                scatterSpots: [
                  for (final spot in spots)
                    ScatterSpot(
                      spot.x,
                      spot.y,
                      dotPainter: FlDotCirclePainter(
                        radius: 9,
                        color: Colors.indigo,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
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
