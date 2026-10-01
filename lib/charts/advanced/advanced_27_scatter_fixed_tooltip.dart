import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced27ScatterFixedTooltip extends StatelessWidget {
  const Advanced27ScatterFixedTooltip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('27. Tooltip manual en dispersión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: ScatterChart(
              ScatterChartData(
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                scatterTouchData: ScatterTouchData(
                  handleBuiltInTouches: false,
                ),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 2,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2,
                    ),
                  ),
                ),
                showingTooltipIndicators: [1],
                scatterSpots: [
                  ScatterSpot(2, 3.5),
                  ScatterSpot(5, 6.2),
                  ScatterSpot(7.5, 4.4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
