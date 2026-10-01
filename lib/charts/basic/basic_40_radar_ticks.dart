import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic40RadarTicks extends StatelessWidget {
  const Basic40RadarTicks({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Ataque', 'Defensa', 'Drible', 'Pase', 'Tiro'];

    return Scaffold(
      appBar: AppBar(title: const Text('40. Radar con rejilla y marcas (ticks)')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.1,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.circle,
                tickCount: 5,
                radarBackgroundColor: Colors.indigo.withValues(alpha: 0.05),
                gridBorderData: const BorderSide(color: Colors.indigo, width: 1.5),
                tickBorderData: const BorderSide(
                  color: Colors.indigo,
                  width: 1,
                ),
                radarBorderData: const BorderSide(
                  color: Colors.indigo,
                  width: 2,
                ),
                ticksTextStyle: const TextStyle(
                  fontSize: 9,
                  color: Colors.black45,
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
                      RadarEntry(value: 78),
                      RadarEntry(value: 65),
                      RadarEntry(value: 88),
                      RadarEntry(value: 72),
                      RadarEntry(value: 60),
                    ],
                    fillColor: Colors.orange.withValues(alpha: 0.35),
                    borderColor: Colors.orange,
                    borderWidth: 2,
                    entryRadius: 5,
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
