import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic35ScatterBasic extends StatelessWidget {
  const Basic35ScatterBasic({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bottomTitle(double value, TitleMeta meta) {
      if (value % 20 != 0) return const SizedBox.shrink();
      return SideTitleWidget(
        meta: meta,
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    Widget leftTitle(double value, TitleMeta meta) {
      if (value % 20 != 0) return const SizedBox.shrink();
      return Text(
        value.toInt().toString(),
        style: const TextStyle(fontSize: 12),
      );
    }

    final spots = [
      ScatterSpot(8, 22),
      ScatterSpot(15, 34),
      ScatterSpot(24, 30),
      ScatterSpot(33, 52),
      ScatterSpot(41, 44),
      ScatterSpot(50, 63),
      ScatterSpot(58, 58),
      ScatterSpot(66, 75),
      ScatterSpot(73, 69),
      ScatterSpot(81, 88),
      ScatterSpot(90, 80),
      ScatterSpot(95, 94),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('35. Dispersión simple')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: ScatterChart(
              ScatterChartData(
                minX: 0,
                maxX: 100,
                minY: 0,
                maxY: 100,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  verticalInterval: 20,
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
                      reservedSize: 30,
                      getTitlesWidget: leftTitle,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: bottomTitle,
                    ),
                  ),
                ),
                scatterSpots: [
                  for (var i = 0; i < spots.length; i++)
                    ScatterSpot(
                      spots[i].x,
                      spots[i].y,
                      dotPainter: FlDotCirclePainter(
                        radius: 8,
                        color: i.isEven
                            ? Colors.blue
                            : Colors.blue.withValues(alpha: 0.55),
                        strokeWidth: 1,
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
