import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic38RadarCircle extends StatelessWidget {
  const Basic38RadarCircle({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Dormitorio', 'Cocina', 'Baño', 'Salón', 'Jardín'];

    return Scaffold(
      appBar: AppBar(title: const Text('38. Radar circular')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.1,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.circle,
                tickCount: 4,
                gridBorderData: const BorderSide(color: Colors.grey, width: 1),
                tickBorderData: const BorderSide(color: Colors.grey, width: 1),
                radarBorderData: const BorderSide(color: Colors.grey, width: 1),
                ticksTextStyle: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
                titleTextStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                getTitle: (index, angle) =>
                    RadarChartTitle(text: labels[index % labels.length]),
                dataSets: [
                  RadarDataSet(
                    dataEntries: const [
                      RadarEntry(value: 64),
                      RadarEntry(value: 82),
                      RadarEntry(value: 55),
                      RadarEntry(value: 91),
                      RadarEntry(value: 73),
                    ],
                    fillColor: Colors.cyan.withValues(alpha: 0.4),
                    borderColor: Colors.cyan,
                    borderWidth: 2,
                    entryRadius: 4,
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
