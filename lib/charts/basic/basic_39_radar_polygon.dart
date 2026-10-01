import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic39RadarPolygon extends StatelessWidget {
  const Basic39RadarPolygon({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Android', 'iOS', 'Web', 'Escritorio', 'Servidor'];

    return Scaffold(
      appBar: AppBar(title: const Text('39. Radar poligonal')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.1,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
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
                      RadarEntry(value: 90),
                      RadarEntry(value: 75),
                      RadarEntry(value: 65),
                      RadarEntry(value: 80),
                      RadarEntry(value: 55),
                    ],
                    fillColor: Colors.teal.withValues(alpha: 0.4),
                    borderColor: Colors.teal,
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
