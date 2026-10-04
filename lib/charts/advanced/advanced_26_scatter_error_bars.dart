import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced26ScatterErrorBars extends StatelessWidget {
  const Advanced26ScatterErrorBars({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('26. Dispersión con barras de error')),
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
                errorIndicatorData:
                    FlErrorIndicatorData<ScatterChartSpotErrorRangeCallbackInput>(
                  painter: (input) => FlSimpleErrorPainter(
                    lineColor: Colors.purple.shade700,
                    lineWidth: 2,
                    capLength: 10,
                  ),
                ),
                scatterSpots: [
                  ScatterSpot(
                    1.8,
                    2.6,
                    xError: const FlErrorRange(lowerBy: 0.7, upperBy: 0.4),
                    yError: const FlErrorRange(lowerBy: 0.6, upperBy: 0.5),
                  ),
                  ScatterSpot(
                    4.6,
                    7.1,
                    xError: const FlErrorRange(lowerBy: 0.5, upperBy: 0.9),
                    yError: const FlErrorRange(lowerBy: 0.8, upperBy: 0.4),
                  ),
                  ScatterSpot(
                    8.2,
                    5.3,
                    xError: const FlErrorRange(lowerBy: 0.9, upperBy: 0.3),
                    yError: const FlErrorRange(lowerBy: 0.4, upperBy: 0.7),
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
