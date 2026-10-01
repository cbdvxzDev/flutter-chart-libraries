import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced33RadarCustomTitle extends StatelessWidget {
  const Advanced33RadarCustomTitle({super.key});

  static const labels = [
    'Ventas',
    'Marketing',
    'Producto',
    'Soporte',
    'Finanzas',
    'Tecnología',
  ];
  static const List<double> values = [78, 64, 91, 55, 70, 86];

  static RadarChartTitle buildTitle(int index, double angle) {
    return RadarChartTitle(
      text: labels[index],
      angle: angle,
      positionPercentageOffset: 0.1,
      children: [
        TextSpan(
          text: '\n${values[index]}',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.deepOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('33. Radar con títulos personalizados')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.3,
            child: RadarChart(
              RadarChartData(
                isMinValueAtCenter: true,
                tickCount: 5,
                titlePositionPercentageOffset: 0.35,
                titleTextStyle: const TextStyle(fontSize: 12),
                radarBorderData: BorderSide(color: Colors.grey.shade400),
                gridBorderData: BorderSide(color: Colors.grey.shade300),
                tickBorderData: BorderSide(color: Colors.grey.shade400),
                ticksTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
                getTitle: buildTitle,
                dataSets: [
                  RadarDataSet(
                    dataEntries: [
                      for (final v in values) RadarEntry(value: v),
                    ],
                    fillColor: Colors.indigo.withValues(alpha: 0.4),
                    borderColor: const Color(0xFF283593),
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
