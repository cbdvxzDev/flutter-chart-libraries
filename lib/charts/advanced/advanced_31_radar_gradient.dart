import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced31RadarGradient extends StatelessWidget {
  const Advanced31RadarGradient({super.key});

  static const labels = ['Comida', 'Salud', 'Hogar', 'Viajes', 'Ahorro', 'Ocio'];

  static const List<double> values = [70, 55, 85, 40, 62, 50];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('31. Radar con relleno degradado')),
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
                tickCount: 4,
                ticksTextStyle: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                getTitle: (index, angle) => RadarChartTitle(
                  text: labels[index],
                  angle: angle,
                ),
                dataSets: [
                  RadarDataSet(
                    dataEntries: [
                      for (final v in values) RadarEntry(value: v),
                    ],
                    fillColor: const Color(0xFF7986CB),
                    fillGradient: const LinearGradient(
                      colors: [Color(0xFF7986CB), Color(0xFF0D47A1)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderColor: const Color(0xFF3949AB),
                    borderWidth: 2,
                    entryRadius: 3.5,
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
