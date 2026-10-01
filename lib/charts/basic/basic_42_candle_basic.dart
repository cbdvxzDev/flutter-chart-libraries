import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Basic42CandleBasic extends StatelessWidget {
  const Basic42CandleBasic({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Lun', 'Mar', 'Mié'];
    final spots = <CandlestickSpot>[
      CandlestickSpot(x: 1, open: 102, high: 108, low: 100, close: 106),
      CandlestickSpot(x: 2, open: 106, high: 110, low: 103, close: 104),
      CandlestickSpot(x: 3, open: 104, high: 112, low: 103, close: 111),
      CandlestickSpot(x: 4, open: 111, high: 113, low: 107, close: 108),
      CandlestickSpot(x: 5, open: 108, high: 115, low: 107, close: 114),
      CandlestickSpot(x: 6, open: 114, high: 118, low: 112, close: 116),
      CandlestickSpot(x: 7, open: 116, high: 117, low: 110, close: 112),
      CandlestickSpot(x: 8, open: 112, high: 121, low: 111, close: 120),
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
