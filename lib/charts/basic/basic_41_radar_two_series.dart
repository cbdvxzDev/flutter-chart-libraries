import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic41RadarTwoSeries extends StatelessWidget {
  const Basic41RadarTwoSeries({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Idea', 'Diseño', 'Código', 'Pruebas', 'Entrega'];

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

    return Scaffold(
      appBar: AppBar(title: const Text('41. Radar con dos series')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
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
                          RadarEntry(value: 88),
                          RadarEntry(value: 74),
                          RadarEntry(value: 62),
                          RadarEntry(value: 80),
                          RadarEntry(value: 70),
                        ],
                        fillColor: Colors.pink.withValues(alpha: 0.35),
                        borderColor: Colors.pink,
                        borderWidth: 2,
                        entryRadius: 4,
                      ),
                      RadarDataSet(
                        dataEntries: const [
                          RadarEntry(value: 65),
                          RadarEntry(value: 85),
                          RadarEntry(value: 80),
                          RadarEntry(value: 58),
                          RadarEntry(value: 92),
                        ],
                        fillColor: Colors.deepPurple.withValues(alpha: 0.35),
                        borderColor: Colors.deepPurple,
                        borderWidth: 2,
                        entryRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  legendItem(Colors.pink, 'Equipo A'),
                  legendItem(Colors.deepPurple, 'Equipo B'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
