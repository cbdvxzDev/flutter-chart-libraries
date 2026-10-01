import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced32RadarTouchHighlight extends StatefulWidget {
  const Advanced32RadarTouchHighlight({super.key});

  @override
  State<Advanced32RadarTouchHighlight> createState() =>
      _Advanced32RadarTouchHighlightState();
}

class _Advanced32RadarTouchHighlightState
    extends State<Advanced32RadarTouchHighlight> {
  static const labels = [
    'Ataque',
    'Defensa',
    'Velocidad',
    'Magia',
    'Resistencia',
  ];
  static const List<double> values = [8, 6, 7, 9, 5];

  int? _touchedEntry;

  @override
  Widget build(BuildContext context) {
    final touched = _touchedEntry;

    return Scaffold(
      appBar: AppBar(title: const Text('32. Radar con punto tocado')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.4,
                child: RadarChart(
                  RadarChartData(
                    radarBorderData: BorderSide(color: Colors.grey.shade400),
                    gridBorderData: BorderSide(color: Colors.grey.shade300),
                    tickBorderData: BorderSide(color: Colors.grey.shade400),
                    titlePositionPercentageOffset: 0.28,
                    ticksTextStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    getTitle: (index, angle) => RadarChartTitle(
                      text: labels[index],
                      angle: angle,
                    ),
                    radarTouchData: RadarTouchData(
                      touchCallback: (event, response) {
                        final spot = response?.touchedSpot;
                        setState(() {
                          _touchedEntry = !event.isInterestedForInteractions ||
                                  spot == null
                              ? null
                              : spot.touchedRadarEntryIndex;
                        });
                      },
                    ),
                    dataSets: [
                      RadarDataSet(
                        dataEntries: [
                          for (final v in values) RadarEntry(value: v),
                        ],
                        fillColor: Colors.indigo.withValues(alpha: 0.4),
                        borderColor: const Color(0xFF3949AB),
                        borderWidth: 2,
                        entryRadius: touched == null ? 4 : 6,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                touched == null
                    ? 'Toca un vértice del radar'
                    : '${labels[touched]}: ${values[touched]}/10',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: touched == null ? FontWeight.normal : FontWeight.bold,
                  color: touched == null ? Colors.black87 : Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
