import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced30RadarMultiDataset extends StatelessWidget {
  const Advanced30RadarMultiDataset({super.key});

  static const labels = ['Fuerza', 'Velocidad', 'Magia', 'Resistencia', 'Astucia'];
  static const ticks = ['Bajo', 'Medio', 'Alto', 'Experto'];

  static List<RadarEntry> entries(List<double> values) =>
      [for (final v in values) RadarEntry(value: v)];

  @override
  Widget build(BuildContext context) {
    final hero = entries([9, 7, 4, 6, 8]);
    final rival = entries([5, 9, 8, 4, 6]);
    final ally = entries([6, 5, 7, 9, 5]);

    return Scaffold(
      appBar: AppBar(title: const Text('30. Radar con múltiples series')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.3,
            child: RadarChart(
              RadarChartData(
                radarBorderData: BorderSide(color: Colors.grey.shade400),
                gridBorderData: BorderSide(color: Colors.grey.shade300),
                tickBorderData: BorderSide(color: Colors.grey.shade400),
                ticksTextStyle: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                getTitle: (index, angle) => RadarChartTitle(
                  text: labels[index],
                  angle: angle,
                ),
                dataSets: [
                  RadarDataSet(
                    dataEntries: hero,
                    fillColor: Colors.indigo.withValues(alpha: 0.35),
                    borderColor: Colors.indigo,
                    borderWidth: 2,
                    entryRadius: 3,
                  ),
                  RadarDataSet(
                    dataEntries: rival,
                    fillColor: Colors.deepOrange.withValues(alpha: 0.3),
                    borderColor: Colors.deepOrange,
                    borderWidth: 2,
                    entryRadius: 3,
                  ),
                  RadarDataSet(
                    dataEntries: ally,
                    fillColor: Colors.teal.withValues(alpha: 0.3),
                    borderColor: Colors.teal,
                    borderWidth: 2,
                    entryRadius: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Wrap(
          spacing: 16,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: const [
            _Legend(color: Colors.indigo, label: 'Héroe'),
            _Legend(color: Colors.deepOrange, label: 'Rival'),
            _Legend(color: Colors.teal, label: 'Aliado'),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
