import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced28ScatterLabels extends StatelessWidget {
  const Advanced28ScatterLabels({super.key});

  static const names = ['Duna', 'Roca', 'Nube', 'Faro', 'Lago'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('28. Etiquetas en dispersión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: ScatterChart(
              ScatterChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 6,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                ),
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
                      interval: 1,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                    ),
                  ),
                ),
                scatterLabelSettings: ScatterLabelSettings(
                  showLabel: true,
                  getLabelFunction: _labelOf,
                  getLabelTextStyleFunction: _labelStyleOf,
                ),
                scatterSpots: [
                  ScatterSpot(0.8, 2.1),
                  ScatterSpot(1.9, 4.3),
                  ScatterSpot(2.7, 1.4),
                  ScatterSpot(4.1, 3.6),
                  ScatterSpot(5.4, 5.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _labelOf(int spotIndex, ScatterSpot spot) =>
      names[spotIndex % names.length];

  static TextStyle _labelStyleOf(int spotIndex, ScatterSpot spot) =>
      TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple.shade800,
      );
}
