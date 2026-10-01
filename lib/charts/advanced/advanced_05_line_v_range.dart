import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced05LineVRange extends StatefulWidget {
  const Advanced05LineVRange({super.key});

  @override
  State<Advanced05LineVRange> createState() => _Advanced05LineVRangeState();
}

class _Advanced05LineVRangeState extends State<Advanced05LineVRange> {
  static const labels = ['08', '10', '12', '14', '16', '18', '20', '22'];
  static const List<double> values = [34, 52, 68, 85, 76, 58, 41, 30];
  static const double umbral = 80;

  int? _selected;

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= labels.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    final index = value.toInt();
    final selected = _selected == index;
    return SideTitleWidget(
      meta: meta,
      child: Text(
        '${labels[index]}h',
        style: TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.deepOrange : Colors.black87,
        ),
      ),
    );
  }

  Widget leftTitle(double value, TitleMeta meta) {
    if (value % 20 != 0) return const SizedBox.shrink();
    return Text(
      '${value.toInt()}%',
      style: const TextStyle(fontSize: 11),
    );
  }

  bool _enFranjaPico(int index) => index >= 3 && index <= 5;

  String _detalle(int index) {
    final v = values[index];
    final String estado;
    if (v > umbral) {
      estado = 'supera el umbral';
    } else if (_enFranjaPico(index)) {
      estado = 'franja pico sin incidencias';
    } else {
      estado = 'operación normal';
    }
    return '${labels[index]}:00 — ${v.toInt()}% · $estado';
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return Scaffold(
      appBar: AppBar(title: const Text('05. Rango vertical con umbral y toque')),
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
                    rangeAnnotations: RangeAnnotations(
                      verticalRangeAnnotations: [
                        VerticalRangeAnnotation(
                          x1: 3,
                          x2: 5,
                          color: Colors.amber.withValues(alpha: 0.16),
                        ),
                        VerticalRangeAnnotation(
                          x1: 6,
                          x2: 7,
                          color: Colors.teal.withValues(alpha: 0.12),
                        ),
                      ],
                    ),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: umbral,
                          color: Colors.red.shade600,
                          strokeWidth: 1.5,
                          dashArray: const [6, 4],
                          label: HorizontalLineLabel(
                            show: true,
                            labelResolver: (_) =>
                                'Umbral ${umbral.toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ),
                      ],
                    ),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final v = spot.y;
                            return LineTooltipItem(
                              '${labels[spot.x.toInt()]}:00\n'
                              '${v.toInt()}% ${v > umbral ? '(alto)' : '(ok)'}',
                              TextStyle(
                                color: v > umbral
                                    ? Colors.red.shade700
                                    : Colors.teal.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          interval: 20,
                          getTitlesWidget: leftTitle,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
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
                        color: Colors.indigo,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                selected == null
                    ? 'Toca una hora para ver su consumo (banda ámbar = franja pico)'
                    : _detalle(selected),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      selected == null ? FontWeight.normal : FontWeight.bold,
                  color: selected == null
                      ? Colors.black54
                      : values[selected] > umbral
                          ? Colors.red.shade700
                          : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
