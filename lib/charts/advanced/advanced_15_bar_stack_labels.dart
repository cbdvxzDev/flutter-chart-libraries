import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced15BarStackLabels extends StatefulWidget {
  const Advanced15BarStackLabels({super.key});

  @override
  State<Advanced15BarStackLabels> createState() =>
      _Advanced15BarStackLabelsState();
}

class _Advanced15BarStackLabelsState extends State<Advanced15BarStackLabels> {
  static const groups = ['Nuevos', 'Fieles', 'Inactivos', 'VIP'];
  static const segmentos = ['Membresías', 'Publicidad', 'Servicios'];
  static const colors = [Colors.cyan, Colors.amber, Colors.purple];
  static const List<List<double>> datos = [
    [36, 41, 27],
    [49, 25, 34],
    [28, 37, 22],
    [44, 19, 31],
  ];

  int? _grupo;
  int? _segmento;

  double _acumulado(int groupIndex, int hasta) {
    var suma = 0.0;
    for (var i = 0; i < hasta; i++) {
      suma += datos[groupIndex][i];
    }
    return suma;
  }

  double _total(int groupIndex) => _acumulado(groupIndex, segmentos.length);

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= groups.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    final index = value.toInt();
    final selected = _grupo == index;
    return SideTitleWidget(
      meta: meta,
      child: Text(
        groups[index],
        style: TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.deepOrange : Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grupo = _grupo ?? -1;
    final segmento = _segmento ?? -1;
    final haySeleccion = grupo >= 0 && segmento >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('15. Apiladas con selección de segmento'),
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
                    maxY: 120,
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
                        final spot = response?.spot;
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              spot == null ||
                              spot.touchedStackItemIndex < 0) {
                            _grupo = null;
                            _segmento = null;
                          } else {
                            _grupo = spot.touchedBarGroupIndex;
                            _segmento = spot.touchedStackItemIndex;
                          }
                        });
                      },
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) {
                          if (haySeleccion && grupo == group.x) {
                            return colors[segmento];
                          }
                          return Colors.blueGrey.shade700;
                        },
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          if (!haySeleccion || grupo != groupIndex) {
                            return BarTooltipItem(
                              'Total: ${rod.toY.toInt()}',
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return BarTooltipItem(
                            '${segmentos[segmento]}: ${datos[groupIndex][segmento].toInt()}',
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
                    barGroups: [
                      for (var g = 0; g < groups.length; g++)
                        BarChartGroupData(
                          x: g,
                          barRods: [
                            BarChartRodData(
                              toY: _total(g),
                              width: 40,
                              color: Colors.grey.shade300,
                              rodStackItems: [
                                for (var s = 0; s < segmentos.length; s++)
                                  BarChartRodStackItem(
                                    _acumulado(g, s),
                                    _acumulado(g, s) + datos[g][s],
                                    _colorDe(g, s),
                                    label: datos[g][s].toInt().toString(),
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    borderSide: haySeleccion &&
                                            grupo == g &&
                                            segmento == s
                                        ? const BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          )
                                        : BorderSide.none,
                                  ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  for (var s = 0; s < segmentos.length; s++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[s],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(segmentos[s], style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                haySeleccion
                    ? '${groups[grupo]} · ${segmentos[segmento]}: '
                        '${datos[grupo][segmento].toInt()} de '
                        '${_total(grupo).toInt()}'
                    : 'Toca un segmento para seleccionarlo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: haySeleccion ? FontWeight.bold : FontWeight.normal,
                  color: haySeleccion ? Colors.black87 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorDe(int groupIndex, int segmentoIndex) {
    final base = colors[segmentoIndex];
    final atenuado =
        _grupo != null && (_grupo != groupIndex || _segmento != segmentoIndex);
    return atenuado ? base.withValues(alpha: 0.45) : base;
  }
}
