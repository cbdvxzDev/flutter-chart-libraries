import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced12LineHighlightDots extends StatefulWidget {
  const Advanced12LineHighlightDots({super.key});

  @override
  State<Advanced12LineHighlightDots> createState() =>
      _Advanced12LineHighlightDotsState();
}

class _Advanced12LineHighlightDotsState
    extends State<Advanced12LineHighlightDots> {
  static const labels = ['H1', 'H2', 'H3', 'H4', 'H5', 'H6'];
  static const List<double> values = [59, 67, 63, 75, 71, 80];

  int? _touched;

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= labels.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    final index = value.toInt();
    final selected = _touched == index;
    return SideTitleWidget(
      meta: meta,
      child: Text(
        labels[index],
        style: TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.deepOrange : Colors.black87,
        ),
      ),
    );
  }

  bool _esExtremo(double x) => x == 0 || x == labels.length - 1;

  @override
  Widget build(BuildContext context) {
    final touched = _touched;

    return Scaffold(
      appBar: AppBar(
        title: const Text('12. Puntos destacados con selección táctil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: labels.length - 1,
                    minY: 0,
                    maxY: 100,
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: false,
                      touchCallback: (event, response) {
                        final spot = response?.lineBarSpots?.first;
                        setState(() {
                          _touched =
                              !event.isInterestedForInteractions || spot == null
                                  ? null
                                  : spot.spotIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 20,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: bottomTitle,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < labels.length; i++)
                            FlSpot(i.toDouble(), values[i]),
                        ],
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, barData) =>
                              _esExtremo(spot.x) || spot.x == touched,
                          getDotPainter: (spot, percent, bar, index) {
                            final seleccionado = spot.x == touched;
                            if (seleccionado) {
                              return FlDotCirclePainter(
                                radius: 9,
                                color: Colors.deepOrange,
                                strokeWidth: 2.5,
                                strokeColor: Colors.white,
                              );
                            }
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: Colors.blue,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                touched == null
                    ? 'Solo se marcan los extremos: toca cualquier punto'
                    : _detalle(touched),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: touched == null ? FontWeight.normal : FontWeight.bold,
                  color: touched == null ? Colors.black54 : Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _detalle(int index) {
    final actual = values[index];
    final anterior = index > 0 ? values[index - 1] : null;
    if (anterior == null) {
      return '${labels[index]}: ${actual.toInt()} u. · primer mes del periodo';
    }
    final delta = actual - anterior;
    final signo = delta >= 0 ? '+' : '';
    return '${labels[index]}: ${actual.toInt()} u. · '
        '$signo${delta.toInt()} frente a ${labels[index - 1]}';
  }
}
