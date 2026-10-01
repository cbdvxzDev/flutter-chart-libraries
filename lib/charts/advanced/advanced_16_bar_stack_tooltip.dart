import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced16BarStackTooltip extends StatefulWidget {
  const Advanced16BarStackTooltip({super.key});

  @override
  State<Advanced16BarStackTooltip> createState() =>
      _Advanced16BarStackTooltipState();
}

class _Advanced16BarStackTooltipState
    extends State<Advanced16BarStackTooltip> {
  BarChartRodStackItem? _touchedStack;

  static const labels = ['Web', 'App', 'Tienda'];

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= labels.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(labels[value.toInt()], style: const TextStyle(fontSize: 11)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('16. Tooltip sobre segmento apilado')),
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
                    maxY: 110,
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
                        final stack =
                            response?.spot?.touchedStackItem;
                        if (stack == _touchedStack) return;
                        setState(() => _touchedStack = stack);
                      },
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final tocado = _touchedStack;
                          if (tocado == null) {
                            return BarTooltipItem(
                              'Total ${rod.toY.toInt()}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            );
                          }
                          final nombre = tocado.toY <= 45
                              ? 'Web'
                              : tocado.toY <= 75
                                  ? 'App'
                                  : 'Tienda';
                          final valor = tocado.toY - tocado.fromY;
                          return BarTooltipItem(
                            '$nombre: ${valor.toInt()}',
                            TextStyle(
                              color: tocado.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
                      for (var i = 0; i < labels.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: 100 - i * 12,
                              width: 34,
                              color: Colors.grey.shade300,
                              rodStackItems: [
                                BarChartRodStackItem(
                                  0,
                                  45 - i * 4,
                                  Colors.indigo,
                                ),
                                BarChartRodStackItem(
                                  45 - i * 4,
                                  75 - i * 6,
                                  Colors.teal,
                                ),
                                BarChartRodStackItem(
                                  75 - i * 6,
                                  100 - i * 12,
                                  Colors.orange,
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
              Text(
                _touchedStack == null
                    ? 'Toca una barra para ver el segmento'
                    : 'Segmento tocado: ${_touchedStack!.toY - _touchedStack!.fromY} unidades',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
