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
  static const List<(double, double, double)> points = [
    (1.5, 2.0, 10),
    (3.0, 4.5, 40),
    (5.5, 3.0, 16),
    (7.0, 6.2, 40),
    (4.0, 1.5, 22),
  ];

  int _touchedIndex = -1;

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
              AspectRatio(
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
                      touchSpotThreshold: 40,
                      touchCallback: (event, response) {
                        final spot = response?.touchedSpot;
                        setState(() {
                          _touchedIndex =
                              !event.isInterestedForInteractions || spot == null
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
                      for (var i = 0; i < points.length; i++)
                        ScatterSpot(
                          points[i].$1,
                          points[i].$2,
                          dotPainter: FlDotCirclePainter(
                            radius: _touchedIndex == i
                                ? 14
                                : 6 + points[i].$3 / 14,
                            color: _touchedIndex == i
                                ? Colors.deepOrange
                                : Colors.indigo,
                            strokeWidth: _touchedIndex == i ? 3 : 0,
                            strokeColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _touchedIndex < 0
                    ? 'Toca un punto (los mayores tienen más área táctil)'
                    : 'Punto ${_touchedIndex + 1} tocado, prioridad ${points[_touchedIndex].$3}',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
