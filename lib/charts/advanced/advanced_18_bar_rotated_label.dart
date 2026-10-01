import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced18BarRotatedLabel extends StatefulWidget {
  const Advanced18BarRotatedLabel({super.key});

  @override
  State<Advanced18BarRotatedLabel> createState() =>
      _Advanced18BarRotatedLabelState();
}

class _Advanced18BarRotatedLabelState extends State<Advanced18BarRotatedLabel> {
  static const labels = ['Norte', 'Sur', 'Centro', 'Oeste', 'Este'];
  static const List<double> completado = [62, 45, 78, 55, 68];
  static const List<double> pendiente = [18, 30, 12, 25, 22];

  int? _selected;

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= labels.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    final index = value.toInt();
    final selected = _selected == index;
    return SideTitleWidget(
      meta: meta,
      space: 14,
      angle: -math.pi / 4,
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

  Widget leftTitle(double value, TitleMeta meta) {
    if (value % 20 != 0) return const SizedBox.shrink();
    return Text(
      value.toInt().toString(),
      style: const TextStyle(fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    const total = 100.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('18. Agrupación vertical con etiquetas rotadas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: total,
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    barTouchData: BarTouchData(
                      touchCallback: (event, response) {
                        final index = response?.spot?.touchedBarGroupIndex;
                        setState(() {
                          _selected =
                              !event.isInterestedForInteractions || index == null
                                  ? null
                                  : index;
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) {
                          final index = group.x;
                          return _selected == index
                              ? Colors.deepOrange.shade700
                              : Colors.blueGrey.shade700;
                        },
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final nombre =
                              rodIndex == 0 ? 'Completado' : 'Pendiente';
                          return BarTooltipItem(
                            '$nombre: ${rod.toY.toInt()}',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 20,
                          getTitlesWidget: leftTitle,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 54,
                          interval: 1,
                          getTitlesWidget: bottomTitle,
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var i = 0; i < labels.length; i++)
                        BarChartGroupData(
                          x: i,
                          groupVertically: true,
                          barRods: [
                            BarChartRodData(
                              fromY: 0,
                              toY: completado[i],
                              width: 26,
                              color: Colors.indigo,
                              borderRadius: BorderRadius.zero,
                              borderSide: _selected == i
                                  ? const BorderSide(
                                      color: Colors.deepOrange,
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            ),
                            BarChartRodData(
                              fromY: completado[i],
                              toY: completado[i] + pendiente[i],
                              width: 26,
                              color: Colors.blueGrey.shade200,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                              borderSide: _selected == i
                                  ? const BorderSide(
                                      color: Colors.deepOrange,
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: const [
                  _Legend(color: Colors.indigo, label: 'Completado'),
                  _Legend(color: Colors.blueGrey, label: 'Pendiente'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                selected == null
                    ? 'Toca una región para comparar sus dos barras'
                    : _resumen(selected),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      selected == null ? FontWeight.normal : FontWeight.bold,
                  color: selected == null ? Colors.black54 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resumen(int index) {
    final totalGrupo = completado[index] + pendiente[index];
    final porcentaje = (completado[index] / totalGrupo * 100).round();
    return '${labels[index]}: ${completado[index].toInt()} de '
        '${totalGrupo.toInt()} completados ($porcentaje%)';
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
