import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Advanced19BarFixedTooltip extends StatelessWidget {
  const Advanced19BarFixedTooltip({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    const List<double> values = [58, 34, 76, 45, 88, 62];
    const resaltado = 4;

    Widget bottomTitle(double value, TitleMeta meta) {
      if (value < 0 || value >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(labels[value.toInt()], style: const TextStyle(fontSize: 11)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('19. Tooltip fijo con contenido propio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.4,
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
                        handleBuiltInTouches: false,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) =>
                              group.barRods.first.toY >= 70
                                  ? Colors.indigo.shade700
                                  : Colors.deepOrange.shade700,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                              BarTooltipItem(
                                '${labels[groupIndex]}\n${rod.toY.toInt()} pedidos',
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  height: 1.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                        for (var i = 0; i < values.length; i++)
                          BarChartGroupData(
                            x: i,
                            showingTooltipIndicators:
                                i == resaltado ? [0] : const [],
                            barRods: [
                              BarChartRodData(
                                toY: values[i],
                                width: 18,
                                color: i == resaltado
                                    ? Colors.deepOrange
                                    : Colors.indigo.withValues(alpha: 0.6),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'showingTooltipIndicators en el grupo 4 · getTooltipItem y '
                'getTooltipColor definen contenido y color del popup',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
