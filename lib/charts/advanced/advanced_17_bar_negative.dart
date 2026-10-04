import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced17BarNegative extends StatefulWidget {
  const Advanced17BarNegative({super.key});

  @override
  State<Advanced17BarNegative> createState() => _Advanced17BarNegativeState();
}

class _Advanced17BarNegativeState extends State<Advanced17BarNegative> {
  static const labels = ['B1', 'B2', 'B3', 'B4', 'B5', 'B6'];
  static const List<double> values = [34, -22, 51, -46, 29, -15];

  static const double meta = 40;
  static const double alerta = -40;

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

  String _detalle(int index) {
    final v = values[index];
    final String estado;
    if (v <= alerta) {
      estado = 'zona de alerta';
    } else if (v < 0) {
      estado = 'resultado negativo';
    } else if (v >= meta) {
      estado = 'meta superada';
    } else {
      estado = 'por debajo de la meta';
    }
    final signo = v >= 0 ? '+' : '';
    return '${labels[index]}: $signo${v.toInt()} u. · $estado';
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return Scaffold(
      appBar: AppBar(
        title: const Text('17. Barras negativas con meta y alertas'),
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
                    minY: -60,
                    maxY: 60,
                    baselineY: 0,
                    rangeAnnotations: RangeAnnotations(
                      horizontalRangeAnnotations: [
                        HorizontalRangeAnnotation(
                          y1: -60,
                          y2: alerta,
                          color: Colors.red.withValues(alpha: 0.12),
                        ),
                        HorizontalRangeAnnotation(
                          y1: meta,
                          y2: 60,
                          color: Colors.green.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: 0,
                          color: Colors.black54,
                          strokeWidth: 1.2,
                          label: HorizontalLineLabel(
                            show: true,
                            labelResolver: (_) => 'Cero',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                        HorizontalLine(
                          y: meta,
                          color: Colors.green.shade700,
                          strokeWidth: 1.5,
                          dashArray: const [6, 4],
                          label: HorizontalLineLabel(
                            show: true,
                            labelResolver: (_) => 'Meta ${meta.toInt()}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ),
                      ],
                    ),
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
                          final v = group.barRods.first.toY;
                          return v >= 0
                              ? Colors.green.shade700
                              : Colors.red.shade700;
                        },
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final v = rod.toY;
                          final signo = v >= 0 ? '+' : '';
                          return BarTooltipItem(
                            '${labels[groupIndex]}\n$signo${v.toInt()} u.',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
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
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: bottomTitle,
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var i = 0; i < values.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              fromY: 0,
                              toY: values[i],
                              width: 22,
                              color: _selected == i
                                  ? Colors.deepOrange
                                  : values[i] >= 0
                                      ? Colors.green.shade600
                                      : Colors.red.shade500,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                  values[i] >= 0 ? 5 : 0,
                                ),
                                bottom: Radius.circular(
                                  values[i] >= 0 ? 0 : 5,
                                ),
                              ),
                              borderSide: _selected == i
                                  ? const BorderSide(
                                      color: Colors.white,
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
              Text(
                selected == null
                    ? 'Toca una barra para ver el detalle del mes'
                    : _detalle(selected),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      selected == null ? FontWeight.normal : FontWeight.bold,
                  color: selected == null
                      ? Colors.black54
                      : values[selected] >= 0
                          ? Colors.green.shade800
                          : Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
