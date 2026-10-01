import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced20BarTouchSelection extends StatefulWidget {
  const Advanced20BarTouchSelection({super.key});

  @override
  State<Advanced20BarTouchSelection> createState() =>
      _Advanced20BarTouchSelectionState();
}

class _Advanced20BarTouchSelectionState
    extends State<Advanced20BarTouchSelection> {
  static const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
  static const List<double> values = [42, 55, 48, 62, 57, 71];

  int? _selected;

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
      appBar: AppBar(title: const Text('20. Selección de barra al tocar')),
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
                    barTouchData: BarTouchData(
                      touchCallback: (event, response) {
                        final index =
                            response?.spot?.touchedBarGroupIndex;
                        if (!event.isInterestedForInteractions) {
                          setState(() => _selected = null);
                        } else {
                          setState(() => _selected = index);
                        }
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
                    barGroups: [
                      for (var i = 0; i < values.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: values[i],
                              width: 20,
                              color: _selected == i
                                  ? Colors.deepOrange
                                  : Colors.indigo,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
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
              const SizedBox(height: 12),
              Text(
                _selected == null
                    ? 'Toca una barra para seleccionarla'
                    : '${labels[_selected!]}: ${values[_selected!].toInt()} unidades',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
