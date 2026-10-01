import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced03LineVerticalLine extends StatelessWidget {
  const Advanced03LineVerticalLine({super.key});

  static const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  static const List<double> values = [120, 128, 119, 165, 158, 141, 136];
  static const int evento = 3;

  Widget bottomTitle(double value, TitleMeta meta) {
    if (value < 0 || value >= labels.length || value % 1 != 0) {
      return const SizedBox.shrink();
    }
    final index = value.toInt();
    final esEvento = index == evento;
    return SideTitleWidget(
      meta: meta,
      child: Text(
        labels[index],
        style: TextStyle(
          fontSize: 11,
          fontWeight: esEvento ? FontWeight.bold : FontWeight.normal,
          color: esEvento ? Colors.deepPurple : Colors.black87,
        ),
      ),
    );
  }

  Widget leftTitle(double value, TitleMeta meta) {
    if (value % 30 != 0) return const SizedBox.shrink();
    return Text(
      value.toInt().toString(),
      style: const TextStyle(fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('03. Línea vertical de evento')),
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
                    maxY: 180,
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 30,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    extraLinesData: ExtraLinesData(
                      verticalLines: [
                        VerticalLine(
                          x: evento.toDouble(),
                          color: Colors.deepPurple,
                          strokeWidth: 1.5,
                          dashArray: const [6, 4],
                          label: VerticalLineLabel(
                            show: true,
                            labelResolver: (_) => 'Lanzamiento v2.0',
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                      ],
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 30,
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
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < labels.length; i++)
                            FlSpot(i.toDouble(), values[i]),
                        ],
                        color: Colors.indigo,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            final esEvento = index == evento;
                            return FlDotCirclePainter(
                              radius: esEvento ? 7 : 3,
                              color: esEvento ? Colors.deepPurple : Colors.indigo,
                              strokeWidth: esEvento ? 2.5 : 0,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  children: [
                    const TextSpan(text: 'Evento: '),
                    TextSpan(
                      text: '${labels[evento]} — lanzamiento v2.0',
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' (${values[evento]} visitas frente a ${values[evento - 1]} del día anterior)',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
