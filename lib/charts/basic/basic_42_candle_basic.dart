import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic42CandleBasic extends StatelessWidget {
  const Basic42CandleBasic({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Lun', 'Mar', 'Mié'];
    final spots = <CandlestickSpot>[
      CandlestickSpot(x: 1, open: 88, high: 94, low: 86, close: 93),
      CandlestickSpot(x: 2, open: 93, high: 96, low: 89, close: 90),
      CandlestickSpot(x: 3, open: 90, high: 97, low: 88, close: 96),
      CandlestickSpot(x: 4, open: 96, high: 99, low: 92, close: 94),
      CandlestickSpot(x: 5, open: 94, high: 101, low: 93, close: 100),
      CandlestickSpot(x: 6, open: 100, high: 103, low: 97, close: 98),
      CandlestickSpot(x: 7, open: 98, high: 105, low: 96, close: 104),
      CandlestickSpot(x: 8, open: 104, high: 109, low: 102, close: 107),
    ];

    Widget bottomTitle(double value, TitleMeta meta) {
      final index = value.toInt() - 1;
      if (index < 0 || index >= labels.length || value % 1 != 0) {
        return const SizedBox.shrink();
      }
      return SideTitleWidget(
        meta: meta,
        child: Text(
          labels[index],
          style: const TextStyle(fontSize: 12),
        ),
      );
    }

    Widget leftTitle(double value, TitleMeta meta) {
      if (value % 5 != 0) return const SizedBox.shrink();
      return Text(
        value.toInt().toString(),
        style: const TextStyle(fontSize: 12),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('42. Velas (candlestick) básico')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.4,
            child: CandlestickChart(
              CandlestickChartData(
                candlestickSpots: spots,
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
