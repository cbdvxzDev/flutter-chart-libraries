import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced33RadarCustomTitle extends StatefulWidget {
  const Advanced33RadarCustomTitle({super.key});

  @override
  State<Advanced33RadarCustomTitle> createState() =>
      _Advanced33RadarCustomTitleState();
}

class _Advanced33RadarCustomTitleState extends State<Advanced33RadarCustomTitle> {
  static const labels = [
    'Ventas',
    'Marketing',
    'Producto',
    'Soporte',
    'Finanzas',
    'Tecnología',
  ];
  static const List<double> values = [78, 64, 91, 55, 70, 86];
  static const List<double> metas = [75, 70, 85, 62, 68, 80];

  int? _tocada;

  RadarChartTitle _titulo(int index, double angle) {
    final tocado = _tocada == index;
    final delta = values[index] - metas[index];
    return RadarChartTitle(
      text: labels[index],
      angle: angle,
      positionPercentageOffset: tocado ? 0.52 : 0.35,
      children: [
        TextSpan(
          text: '\n${values[index].toInt()} / ${metas[index].toInt()}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: tocado ? FontWeight.bold : FontWeight.w500,
            color: tocado ? Colors.deepOrange : Colors.orange.shade800,
          ),
        ),
        if (tocado)
          TextSpan(
            text: '\n${delta > 0 ? '+' : ''}${delta.toInt()} vs meta',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tocada = _tocada;

    return Scaffold(
      appBar: AppBar(title: const Text('33. Radar con títulos personalizados')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    isMinValueAtCenter: true,
                    tickCount: 5,
                    titlePositionPercentageOffset: 0.35,
                    titleTextStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    radarBorderData: BorderSide(color: Colors.grey.shade400),
                    gridBorderData: BorderSide(color: Colors.grey.shade300),
                    tickBorderData: BorderSide(color: Colors.grey.shade400),
                    ticksTextStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    getTitle: _titulo,
                    radarTouchData: RadarTouchData(
                      touchSpotThreshold: 60,
                      touchCallback: (event, response) {
                        final spot = response?.touchedSpot;
                        setState(() {
                          _tocada =
                              !event.isInterestedForInteractions ||
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
                        borderColor: const Color(0xFF283593),
                        borderWidth: 2,
                        entryRadius: tocada == null ? 4 : 6,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tocada == null
                    ? 'Cada título añade "valor / meta" con RadarChartTitle'
                        '.children · toca cerca de un vértice'
                    : '${labels[tocada]}: ${values[tocada].toInt()} / '
                        '${metas[tocada].toInt()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: tocada == null
                      ? FontWeight.normal
                      : FontWeight.bold,
                  color: tocada == null ? Colors.black54 : Colors.black87,
                ),
              ),
              if (tocada != null)
                Text(
                  'positionPercentageOffset: 0.52 (fuera) frente a 0.35',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
