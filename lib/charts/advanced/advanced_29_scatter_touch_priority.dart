import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced29ScatterTouchPriority extends StatefulWidget {
  const Advanced29ScatterTouchPriority({super.key});

  @override
  State<Advanced29ScatterTouchPriority> createState() =>
      _Advanced29ScatterTouchPriorityState();
}

class _Advanced29ScatterTouchPriorityState
    extends State<Advanced29ScatterTouchPriority> {
  static const List<(double, double, double)> puntos = [
    (1.5, 2.0, 12),
    (3.0, 4.5, 18),
    (5.5, 3.0, 26),
    (5.8, 3.4, 10),
    (7.2, 6.4, 16),
  ];

  int _tocado = -1;

  Widget axisTitle(double value, TitleMeta meta) {
    if (value % 2 != 0) return const SizedBox.shrink();
    return Text(
      value.toInt().toString(),
      style: const TextStyle(fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('29. Prioridad de punto y toque')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: ScatterChart(
                    ScatterChartData(
                      minX: 0,
                      maxX: 9,
                      minY: 0,
                      maxY: 9,
                      gridData: const FlGridData(show: true),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      scatterTouchData: ScatterTouchData(
                        touchSpotThreshold: 20,
                        touchCallback: (event, response) {
                          final spot = response?.touchedSpot;
                          setState(() {
                            _tocado = !event.isInterestedForInteractions ||
                                    spot == null
                                ? -1
                                : spot.spotIndex;
                          });
                        },
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 2,
                            getTitlesWidget: axisTitle,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 2,
                            getTitlesWidget: axisTitle,
                          ),
                        ),
                      ),
                      scatterSpots: [
                        for (var i = 0; i < puntos.length; i++)
                          ScatterSpot(
                            puntos[i].$1,
                            puntos[i].$2,
                            dotPainter: FlDotCirclePainter(
                              radius: _tocado == i
                                  ? puntos[i].$3 + 6
                                  : puntos[i].$3,
                              color: _tocado == i
                                  ? Colors.deepOrange
                                  : Colors.indigo,
                              strokeWidth: _tocado == i ? 3 : 0,
                              strokeColor: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _tocado < 0
                    ? 'Gana el punto con mayor área táctil; si se solapan, '
                        'el último de la lista'
                    : 'Punto ${_tocado + 1} tocado · radio '
                        '${puntos[_tocado].$3.toInt()} px · '
                        '+ touchSpotThreshold: 20',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
