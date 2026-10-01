import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic38RadarCircle extends StatelessWidget {
  const Basic38RadarCircle({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Velocidad', 'Potencia', 'Defensa', 'Resistencia', 'Agilidad'];

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
                      RadarEntry(value: 85),
                      RadarEntry(value: 70),
                      RadarEntry(value: 60),
                      RadarEntry(value: 75),
                      RadarEntry(value: 90),
                    ],
                    fillColor: Colors.indigo.withValues(alpha: 0.4),
                    borderColor: Colors.indigo,
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
