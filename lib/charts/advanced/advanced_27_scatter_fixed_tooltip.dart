import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced27ScatterFixedTooltip extends StatefulWidget {
  const Advanced27ScatterFixedTooltip({super.key});

  @override
  State<Advanced27ScatterFixedTooltip> createState() =>
      _Advanced27ScatterFixedTooltipState();
}

class _Advanced27ScatterFixedTooltipState
    extends State<Advanced27ScatterFixedTooltip> {
  static const nombres = ['edge-1', 'edge-2', 'srv-a', 'srv-b', 'srv-c'];
  static final List<ScatterSpot> puntos = [
    ScatterSpot(
      0.5,
      9.4,
      dotPainter: FlDotCirclePainter(
        radius: 15,
        color: Colors.red.shade600,
        strokeWidth: 2,
        strokeColor: Colors.white,
      ),
    ),
    ScatterSpot(
      9.5,
      0.6,
      dotPainter: FlDotCirclePainter(
        radius: 15,
        color: Colors.red.shade600,
        strokeWidth: 2,
        strokeColor: Colors.white,
      ),
    ),
    ScatterSpot(
      4.4,
      6.7,
      dotPainter: FlDotCirclePainter(
        radius: 9,
        color: Colors.lightBlue.shade700,
      ),
    ),
    ScatterSpot(
      7.6,
      3.2,
      dotPainter: FlDotCirclePainter(
        radius: 9,
        color: Colors.lightBlue.shade700,
      ),
    ),
    ScatterSpot(
      2.8,
      4.1,
      dotPainter: FlDotCirclePainter(radius: 9, color: Colors.teal.shade600),
    ),
  ];

  int _activo = 0;

  int _indice(ScatterSpot spot) {
    final i = puntos.indexWhere((p) => p.x == spot.x && p.y == spot.y);
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('27. Tooltip manual en dispersión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    minX: 0,
                    maxX: 10,
                    minY: 0,
                    maxY: 10,
                    backgroundColor: const Color(0xFFFFF8E1),
                    clipData: FlClipData.all(),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 2,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 2,
                        ),
                      ),
                    ),
                    scatterTouchData: ScatterTouchData(
                      handleBuiltInTouches: false,
                      touchCallback: (event, response) {
                        final spot = response?.touchedSpot;
                        if (!event.isInterestedForInteractions ||
                            spot == null) {
                          return;
                        }
                        setState(() => _activo = _indice(spot.spot));
                      },
                      touchTooltipData: ScatterTouchTooltipData(
                        getTooltipColor: (spot) => _indice(spot) < 2
                            ? Colors.red.shade800
                            : Colors.lightBlue.shade900,
                        getTooltipItems: (spot) {
                          final i = _indice(spot);
                          return ScatterTooltipItem(
                            '${nombres[i]}\n'
                            'x ${puntos[i].x} · y ${puntos[i].y}',
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                    showingTooltipIndicators: [_activo],
                    scatterSpots: puntos,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'showingTooltipIndicators: [$_activo] → ${nombres[_activo]} · '
                'getTooltipItems y getTooltipColor personalizan el contenido',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                'clipData: FlClipData.all() recorta edge-1 y edge-2 en el '
                'borde · backgroundColor: 0xFFFFF8E1',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade700,
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
